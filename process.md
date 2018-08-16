# Starlark Design Process

## Goals

The process aims to achieve the following:

*   The discussion, final state, and evolution of any design proposal is public,
    discoverable, and non-ephemeral.
*   The community can easily participate in both proposing changes and
    critiquing them.
*   There is clarity around the status of a proposal and what is needed to move
    forward.
*   The semantics of the language and API are better specified, and can be
    reimplemented.

The process focuses on a subset of Bazel features. Features that are too
specific, experimental, or temporary are excluded from the process. The goal is
to have a well-defined and well-specified core, that users can rely on.

Although the reference implementation is [Bazel](https://bazel.build/), the
design attempts to be more general and implementation-independent.

## Scope

This document concerns the following areas:

*   The Starlark language (anything stated in the specification)
*   The evaluation of BUILD and .bzl files
*   Functions, objects, methods available in BUILD and .bzl files; with the
    exception of native rules and language-specific API (e.g. js_common)

The following areas are explicitly outside the scope of this design process
(follow the standard
[Bazel review process](https://bazel.build/designs/index.html)):

*   Rules built in Bazel, for example `cc_library`. They should ideally be
    reimplemented using the Starlark API.
*   Language-specific API, for example `java_common` and `apple_common`. They
    are part of a migration out of the built-in rules.
*   Evaluation of `WORKSPACE` files.

In Scope      | Out of scope
------------- | -----------------
glob()        | java_binary()
rule()        | genrule()
ctx.actions() | js_common
depset()      | repository_rule()

## Process

To propose a change affecting Starlark, please follow
[Bazel review process](https://bazel.build/designs/index.html), with a few
exceptions:

*   Before writing a complete proposal, please file an issue and get preliminary
    feedback on your idea.

*   The design index is [in Starlark repository](proposals/README.md).

*   Proposals are announced on
    [starlark@googlegroups.com](https://groups.google.com/forum/#!forum/starlark).

*   Once approved, the proposal has to use markdown (discussions and reviews may
    be done with Google Docs).

Trivial changes to the specification (formatting, clarifications) can be done
directly with a pull request.
