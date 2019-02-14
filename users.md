# Starlark implementations, tools, and users

## Implementations

The implementations below are not fully compliant to the specification yet. We
aim to remove the differences and provide a common test suite.

*   in Go: https://github.com/google/starlark-go/
*   in Java:
    https://github.com/bazelbuild/bazel/tree/master/src/main/java/com/google/devtools/skylark
*   in Rust: https://github.com/google/starlark-rust/

## Tools

* [Buildifier](https://github.com/bazelbuild/buildtools): Code formatter &
  linter. It can also apply automated fixes (e.g. remove unused loads).
* [Stardoc](https://skydoc.bazel.build/): Documentation generator.
* [Starlark Playground](https://github.com/qri-io/starpg): Starlark Playground
  is a web-based starlark editor. It uses the golang implementation of starlark
  running on a server to present a monaco editor set to python syntax.

## IDEs

Some IDEs have a [plugin for Bazel](https://docs.bazel.build/versions/master/ide.html).
Otherwise, consider using a Python mode.

## Users

*  [Skycfg](https://github.com/stripe/skycfg): Library to generate Protocol
   Buffer messages.
*  [Starlight](https://github.com/starlight-go/starlight): Wrapper around the
   interpreter in Go.
*  [starlark-go-nethttp](https://github.com/pcj/starlark-go-nethttp): A wrapper
   around a minimal subset of `net/http package` for use within starlark-go.
*  [Bazel](https://github.com/bazelbuild/bazel): The build system for which
   Starlark was designed.
*  [Buck](https://buckbuild.com/): Another build system, using Starlark in a
   similar way as Bazel.
   *  [OkBuck](https://github.com/uber/okbuck/pull/757): A Gradle-to-Buck migration tool, generating Starlark for Buck.
*  [qri](http://qri.io/): qri is versioned, scriptable, exportable,
   collaborative datasets. They use Starlark to [describe transformations](http://qri.io/docs/reference/skylark_syntax/)
*  [Copybara](https://github.com/google/copybara): A tool for transforming and moving code between repositories.
   They embed Starlark to configure the workflow.
