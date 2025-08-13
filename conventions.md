# Starlark Language Conventions

This document describes non-normative but generally recommended conventions for
Starlark.

## API Documentation

### Docstrings

API documentation for a Starlark module or function should be provided in a
*docstring* - a string literal which is the first line of the module or of the
function's body.

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

No particular markup format for the text is prescribed, but Markdown and HTML
are commonly used in practice. Documentation processors - especially if
interpreting docstrings as Markdown-formatted - should take care to dedent
common leading whitespace from a multiline docstring's lines (note that the
first line could have no leading whitespace).

### Doc comments

API documentation for a global variable may be provided in [Sphinx
autodoc-style](https://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html#doc-comments-and-docstrings)
*doc comments*, which start with `#:` optionally followed by one space.

An uninterrupted block of doc comments attaches to the symbol(s) on the left
hand side of the immediately following assignment statement:

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
