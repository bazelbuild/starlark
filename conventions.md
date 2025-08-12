# Starlark Language Conventions

This document describes non-normative but generally recommended conventions for
Starlark.

## API Documentation

### Docstrings

API documentation for a function should be provided in a [Python-style
docstring](https://peps.python.org/pep-0257/) - a string literal which is the
first line of the function's body.

By convention, this string should consist of an optional newline, followed by
a 1-line, 1-sentence summary, optionally followed by a blank line and blank-line
delimited paragraphs of additional documentation text.

If a string literal is the first statement in a Starlark source file, it is
treated as the documentation for that file; the conventions are the same as for
a function's docstring.

For example:

```python
"""A collection of useful utilities"""

def is_valid(config):
    """
    Verifies if `config` is a valid configuration.

    Usage example:

        is_valid({"example": {"cpu": "arm"}})  # returns True
    """
    ...
```

Documentation processors should take care to dedent common leading whitespace
from a multiline docstring's lines (note that the first line could have no
leading whitespace).

### Doc comments

API documentation for a constant may be provided in
[Sphinx-style](https://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html#doc-comments-and-docstrings)
*doc comments*, which start with `#:` optionally followed by a space.

An uninterrupted block of doc comments attaches to the symbol on the left hand
side of the immediately following assignment statement:

```python
#: List of allowed configuration names
#: in an unspecified order
ALLOWED_CONFIGS = ["foo", "bar"]
```

Alternatively, a one-line trailing doc comment may be given inline after the end
of the right-hand side of an assignment statement:

```python
DEFAULT_TAGS = {
    "foo": [],
    "bar": ["local", "manual"],
} #: Default list of tags for each configuration
```

If both the leading and trailing doc comment is specified, the trailing doc
comment takes precedence.
