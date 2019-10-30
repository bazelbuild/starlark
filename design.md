# Language Design

Starlark was designed at Google to replace Python as the build description
language. To allow a smooth migration of the code, Starlark was intended to be
very similar to Python. We introduced some differences and simplifications
though, to address our distinct requirements, and to help the maintenance of a
large codebase.

The differences with Python stem from different
[design principles](README.md#design-principles). This page documents some of
the choices we made.

# Mutability

Data structures like lists and dicts are mutable; it is possible to add, remove,
or update items. Because Starlark supports parallel evaluation of the code,
there are restrictions in order to guarantee thread-safety and determinism.
Mutable data structures are frozen once they are visible to another execution
thread.

For example, let's define a module Foo with this definition:

```
a_list = [1, 2, 3]
a_list.append(4)
```

A list `a_list` is created and modified. At the end of the evaluation, the list
is frozen and exported. Multiple threads might load the module `Foo`. They will
be able to use the value `a_list` (whose value is `[1, 2, 3, 4]`), but they
cannot mutate it. Calling the method `append` will result in a runtime error.

As the module `Foo` is immutable, its definition can be cached. There is no need
to reevaluate Foo, even if multiple modules access it. A Starlark interpreter
can load many modules in parallel, the exact order doesn't matter, the final
result will be the same.

Similarly, the function `fct` below can be called only from the same module,
before var gets frozen. If any other module calls `fct`, it will result in a
runtime error.

```
var = []

def fct():
  var.append(5)

fct()
```

# Dynamic typing

Like Python, Starlark uses dynamic typing. We considered adding some
restrictions, in order to improve type safety and tooling, but it was not
possible to migrate the existing code. For example, we needed heterogeneous
dictionaries to support the `**kwargs` pattern.

However, it is possible to add type annotations in docstrings, and create a
separate tool to do some type checking.

# Static name resolution

```
def foo(): return undefined_name
```

Unlike Python, Starlark checks statically that every symbol is defined. The code
above causes a static error, even if the function is never called.

Starlark is not as dynamic as Python. This means that this kind of check is
feasible (in Python, it is possible to add or remove global variables at
runtime).

# No exceptions

Starlark has no concept of exceptions. All errors are fatal. While this approach
could be problematic in a general purpose language, this makes the language
simpler and reduces the number of concepts.

This is a very useful thing for the evolution of the language. We can change the
behavior of functions, in cases where they previously raised an error. If a
function `f` accepts only integer arguments, a future version can accept strings
without breaking any existing user. A Starlark code cannot rely on the fact that
a function throws an error, since it cannot catch it.

# No unbounded loops

Support for unbounded loops (e.g. `while`) would encourage users to write more
complex code.

The goal for Starlark is to provide a configuration language. CPU-intensive
computations are better written in another language.

# Single assignment at top-level

Global values cannot be reassigned.

For example, if you see these two lines in a module:

```
magic = 17
def square(x): return x
```

You instantly know what magic and square are, no matter what happens in the rest
of the file. This restriction helps users read and maintain code. It also
provides valuable information to tools, such as IDEs and refactoring tools.

# No for/if statements at top-level

The convention is to wrap any non-trivial code in a function definition. This is
also what happens in other languages, like Java or C++.

Since there is the single assignment rule at top-level, it is not clear what
should be the semantics of variables inside a for or if at top-level. For this
reason, we forbid this pattern.

# Deterministic iteration order for dictionaries

Many languages randomize the iteration order of a dictionary. We don't do that
in Starlark because determinism is a design requirement. This is important in
Bazel to ensure reproducible builds.

# No mutation during iteration

During the iteration of a list or a dictionary, the data structure becomes
temporarily frozen.

Iterating over a data structure and modifying it at the same time can be a
source of confusion or bugs. We forbid it.

You can still modify its deep contents (for example, if you have a list of
lists).

# 1-tuples need surrounding parentheses

In Python, the syntax for tuple literals doesn't require parentheses. While
omitting parentheses is fine in many cases, it can also be error-prone. We made
the syntax of Starlark stricter by requiring tuples with one element to be
surrounded by parentheses:

```
x = max(3, 4, 6),    # parse error
x = (max(3, 4, 6),)  # tuple with one element
```

When we introduced this syntax restriction, we found many bugs in user code.
Python syntax can be confusing: trailing commas are usually meaningless, but
they can sometimes introduce subtle semantic changes.

# No implicit string concatenation

To concatenate two strings, use the `+` operator. Unlike Python, it is not
allowed to concatenate two literal strings by omitting the `+` operator.

In the past, this has been a common source of bugs in user code:

```
arguments = [
    "-c",
    "-O2",
    "-Wall"
    "-Werror",
]
```

This missing comma causes a parse error in Starlark.

According to Guido van Rossum: "This is a fairly common mistake, and IIRC at
Google we even had a lint rule against this (there was also a Python dialect
used for some specific purpose where this was explicitly forbidden)."
([source](https://mail.python.org/pipermail/python-ideas/2013-May/020527.html))
and "I do realize that this will break a lot of code, and that's the only reason
why we may end up punting on this, possibly until Python 4, or forever. But I
don't think the feature is defensible from a language usability POV. It's just
about backward compatibility at this point."
([source](https://mail.python.org/pipermail/python-ideas/2013-May/020557.html))

# Booleans are not integers

Unlike Python, Starlark booleans do not inherit from the int type.
[When booleans were added](https://www.python.org/dev/peps/pep-0285/), Python
developers didn't want to break backwards compatibility. Since comparison
operators were previously returning 0 or 1, they decided to make True and False
compatible with the numbers.

Like in most modern languages, we decided to make bool a separate type.
Following examples will cause a runtime error:

```
True + True
True < 2
```

# Strings are not iterable

Iterable strings have also been a source of bugs in user code.

```python
def fct(srcs):
  new_srcs = [s + ".out" for s in srcs]
  # ...
```

A user wrote the function `fct` above. It first adds the suffix `.out` each
value in a list of strings.

Another user might forget brackets and call the function like this:

```python
fct("myfile")
```

Python would accept the code, as if it was `fct(["m", "y", "f", "i", "l",
"e"])`. This was probably not the user intent, which is why Starlark strings are
not iterable.

# Dictionary literals have no duplicate keys

Dictionaries are a convenient way to store information about a configuration.
Over time, as users add, update, and remove information, some data might be
duplicated by accident.

For example:

```python
defines = select({
    "//conditions:default": [],
    "//tensorflow": ["FOO"],
    "//bazel": ["BAR"],
    # ...
    "//conditions:default": ["BAZ"],
}),
```

When a key is present twice in a dictionary literal, Starlark throws an error
(in Python, the last key wins). This bug has been found surprisingly often in
user code base, which is why we decided to forbid the pattern.

# No is operator

The is operator adds a new concept (identity test) that we did not really need.
In Python, the is operator is implementation-dependent, it can have a
[surprising behavior](https://stackoverflow.com/questions/306313/is-operator-behaves-unexpectedly-with-integers),
and be a source of bugs. Supporting only the equality operator simplified the
language.

# No chained operators

Operator chaining is a feature that most languages don't implement. Although it
can make some code nicer, it is not often useful in practice. Some of the
constructs can be surprising, e.g.

*   `x < y > z`
*   `a in b not in c`

To avoid incompatibilities with Python and to detect potential bugs, we decided
to make the comparison operators non-associative. The examples above will be
rejected by the parser, unless parentheses are added.
