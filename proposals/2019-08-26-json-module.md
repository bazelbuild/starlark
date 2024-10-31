---
title: JSON Module
status: Draft
created: 2019-08-26
updated: 2019-08-26
authors:
  - [jmillikin](https://john-millikin.com)
reviewers:
  - Starlark core reviewers
discussion thread: [#83](https://github.com/bazelbuild/starlark/pull/83)
---

# JSON Module

## Abstract

This document proposes an API for encoding and decoding JSON from Starlark. If accepted, implementations of Starlark
that implement JSON support would be expected to implement this API. The goal is to allow users to write JSON code that
behaves consistently across Starlark implementations.

## Background

JSON is a popular syntax for representing basic data structures. Partial support for parsing or serializing JSON from
Starlark has been independently requested and/or implemented several times:

* Bazel's [`struct`](https://docs.bazel.build/versions/master/skylark/lib/struct.html) type has a `to_json()` method
  that can generate JSON documents. Issue [bazelbuild/bazel#7879](https://github.com/bazelbuild/bazel/issues/7879)
  requests additional control over the behavior of this method (i.e. optional whitespace).

* [bazelbuild/bazel#3732](https://github.com/bazelbuild/bazel/issues/3732) requests support for parsing JSON from
  within a Bazel repository rule, for use with introspecting the state of external tools.

* [`json_parser.bzl`](https://github.com/erickj/bazel_json) is a JSON parser implemented entirely within Starlark.
  Limitations of the Starlark language prevent this parser from being recommended for production use.

* [google/starlark-go#179](https://github.com/google/starlark-go/pull/179) proposes a JSON module for the Go
  implementation of starlark.

* [Skycfg](https://github.com/stripe/skycfg) has a `json.marshal()` method that can generate JSON documents, for use
  with config formats based on JSON syntax.

JSON implementations in the broader community have wildly variant APIs. It is likely that ad-hoc JSON extensions to
Starlark will have different APIs between Starlark implementations.

## Proposed API

The JSON module is a value named `json` in the global namespace. Its API comprises the following functions. Starlark
implementations are not required to support the entire API, but should avoid extending the API with non-standard
functions or parameters.

JSON implementations should comply with the format documented as
[ECMA-404](https://www.ecma-international.org/publications/standards/Ecma-404.htm) and
[RFC 8259](https://www.rfc-editor.org/rfc/rfc8259.html), which supercedes earlier drafts of JSON. In particular, the
only permitted character encoding for contemporary JSON is UTF-8.

To maintain compatibility with existing callers, new required parameters should not be added to these functions. New
optional parameters should be defined using keyword-only parameters
([PEP-3102](https://www.python.org/dev/peps/pep-3102/)).

### json.decode()

The `json.decode()` function decodes a JSON document into a Starlark value.

```python
def json.decode(data):
```

Type conversions are:
* JSON arrays are decoded to Starlark `list` values.
* JSON objects are decoded to Starlark `dict` values. Keys are in the same order as the input data.
* JSON `true`, `false`, and `null` literals are decoded to Starlark `True`, `False`, and `None` respectively.
* JSON strings are decoded to Starlark `string` values.
* JSON numbers with no fractional component are decoded to Starlark `int` values. Starlark implementations without
  arbitrary-precision integers should reject numbers that exceed their supported range.
* JSON numbers with a fractional component may be decoded to an arbitrary-precision or floating-point value, if
  supported by the current Starlark implementation.
  * Starlark implementations without arbitrary-precision numeric values should reject numbers that exceed their
    supported range.

### json.encode()

```python
json.encode(value, *, indent=None, sort_keys=False)
```

Type conversions are:
* Starlark `list` and `tuple` values are encoded to JSON arrays.
* Starlark `dict` values are encoded to JSON objects.
* Starlark values `True`, `False`, and `None` are encoded to JSON `true`, `false`, and `null` respectively.
* Starlark strings are encoded to JSON strings.
* Starlark `int` values are encoded to JSON numbers.

Starlark implementations may support encoding other types

If `indent` is a number, it is how many spaces to indent by. Indent levels less than 1 will only insert newlines.
If `indent` is `None` (the default), JSON will be encoded in one line with no extra spaces.

If `sort_keys` is `True`, then encoded objects' keys are sorted in lexicographical order. If `sort_keys` is `False`
(the default), then object keys are in the same order as the `dict` keys.
