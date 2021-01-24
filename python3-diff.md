# Differences between Python 3 and Starlark

Starlark language is very similar to Python. Starlark tries to
follow the lastest Python 3 syntax and semantics where possible,
but full compatibility with Python is neither possible nor a goal.

This document describes some differences between Python 3 and
Starlark.

The list is incomplete. This document is not normative.

## The differences

* Starlark core evaluation is deterministic (applications may introduce non-determinism).
* Starlark should produce the identical output in any implementation,
  although it is not always possible because of certain details
  like underspecified string.

### Syntax

* Starlark does not support classes, exceptions, generators etc.
* Starlark uses `load` statements in place of imports. Modules are
  not (currently) first class.
* No `for`/`if` at top level (though impls may have a flag).
* There is no `while` loop.
* There is no `is` operator.
* There is no exponentiation (`**`) operator.
* Chained comparisons like `1 < 2 < 3` are not allowed in Starlark.
* Multiple `*args` or `**kwargs` arguments are not allowed in
  Starlark. E. g. `dict(**{}, **{})` is not accepted in Starlark,
  but correct in Python.
* Trailing commas are not allowed in unparenthesized tuples in Starlark.
  For example, these are valid in Python only: `a, = 17`, `return 19,`.
* Unknown escape sequences are not allowed: `"\q"` is `"\\q"` in Python,
  but syntax error in Starlark.
* No implicit string concatenation in Starlark: `"hello " "world"`.
* There is no `set` type or set expression in the language (Go implementation has a flag).
* Variables cannot be assigned to lexically enclosed scope in Starlark
  (there's no `global` or `nonlocal`).

### Semantics

* Starlark has value freezing: all imported variables are frozen (immutable).
* global variables cannot be reassigned (though impls may have a flag).
* No recursion (though impls may have a flag).
* In Python `0 == False` and `1 == True`. In Starlark integers are not equal to booleans.
* Dict expressions cannot have duplicate keys in Starlark: `{"a": 1, "a": 2}`.
* Strings are not iterable in Starlark.
* float NaNs are totally ordered in Starlark: `float("NaN") > 0`.
* Collection is locked for the iteration in Starlark: modification of the collection is not allowed.
  For example, this code is a runtime error in Starlark:

```
l = [1]
for e in l:
    if len(l) < 5:
        l.append(e)
```

### Core Library

* Starlark set of available builtin functions and methods is somewhat different from Python.
* Notably, Starlark excludes "double-underscore" methods such as `__add__`, `__mul__` etc.
* `type(x)` in Starlark returns a string.
* `repr(s)` function uses double quotes for strings in Starlark, and single quotes in Python.
