# Starlark Language Conventions

This document describes non-normative but generally recommended conventions for
Starlark.

## API Documentation

### Docstrings

API documentation for a Starlark module or function should be provided in a
*docstring* - a string literal which is the first statement of the module or of
the function's body.

By convention, this string should consist of an optional newline, followed by
a 1-line, 1-sentence summary, optionally followed by a blank line and blank-line
delimited paragraphs of additional documentation text.

For example:

```python
"""A collection of useful utilities."""

def is_valid(config):
    """
    Verifies if `config` is a valid configuration.

    Usage example:

        is_valid({"example": {"cpu": "arm"}})  # returns True
    """
    ...
```

No particular markup format for the text is prescribed; we observe that Markdown
and HTML are commonly used in practice. Of course, projects and organizations
can specify additional guidelines for their documentation formatting.

Documentation processing tools - especially if interpreting docstrings as
Markdown-formatted - should take care to dedent common leading whitespace from a
multiline docstring's lines (note that the first line could have no leading
whitespace).

### Doc comments

API documentation for a global variable may be provided in [Sphinx
autodoc-style](https://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html#doc-comments-and-docstrings)
*doc comments*, which start with `#:` optionally followed by one space.

An uninterrupted sequence of one or more lines which contain *only* doc comments
(optionally preceded by whitespace before the `#:`) forms a *doc comment block*.
Such a doc comment block attaches to the symbol(s) on the left hand side of the
assignment statement that starts on the immediately following line:

```python
#: List of allowed configuration names
#: in priority order
ALLOWED_CONFIGS = ["foo", "bar"]

#: Default foo map
FOO_MAP, _ = generate_foo_and_bar_maps()
```

Alternatively, a one-line trailing doc comment may be given inline after the end
of the right-hand side of an assignment statement:

```python
DEFAULT_TAGS = {
    "foo": [],
    "bar": ["local", "manual"],
} #: Default list of tags for each configuration
```

Documentation processing tools may treat multiple doc comments attached to the
same variable as an error (for example, if a variable has both a preceding doc
comment block and a trailing in-line doc comment).

Doc comments attach to variables, not to values. For example, if a global
variable whose value happens to be `True` has a doc comment, documentation
processing tools shouldn't attach the doc comment's text to unrelated
occurrences of `True` in other parts of the code.
