---
title: ToolchainInfo Schema
status: Draft
created: 2018-10-03
updated: 2018-10-03
authors:
  - [brandjon@](https://github.com/brandjon)
reviewers:
  - Starlark core reviewers
discussion thread: [#????](https://github.com/bazelbuild/starlark/issues/????)
---

# ToolchainInfo Schema

## Abstract

This doc describes three different ways of structuring data in a `ToolchainInfo` provider. It recommends the third way, which requires an API addition and ideally deprecates the existing way.

## Background

The [toolchain framework](https://docs.bazel.build/versions/master/toolchains.html) takes an abstract dependency of a rule on a toolchain type, and resolves it into a concrete dependency of the rule on a specific tool target implementing that type. For instance, a hypothetical `bar_binary` rule can declare that it needs *some* bar compiler, without saying which one, by requiring `//bar_tools:toolchain_type`. The framework will use platform constraints to translate this into a real dependency on an actual bar compiler such as `//bar_tools:linux_toolchain`.

The concrete toolchain has to pass some information along to the rule that requires it, such as a compiler location, standard library location, and platform-specific flags. For an ordinary dependency this would be done by defining a new provider type for the kind of information being transmitted, e.g. `BarCompilerInfo`, and returning an instance of this provider from the concrete toolchain's rule implementation function. The toolchain framework can't access arbitrary providers of a target, so instead it makes one specific provider available, `ToolchainInfo`, which can encapsulate whatever information the toolchain designer needs to pass along.

```python
def _bar_toolchain_impl(ctx):
    # ToolchainInfo is similar to struct(); it holds arbitrary field-value pairs.
    toolchain_info = ToolchainInfo(
        compiler_path = ctx.attr.compiler_path,
        system_lib = ctx.attr.system_lib,
        arch_flags = ctx.attr.arch_flags,
    )
    # Other providers may be returned here but they would only be seen by
    # targets that directly depend on this one, not targets that find this
    # one via the toolchain framework.
    return [toolchain_info]

... # Omitting definition of bar_toolchain rule.

def _bar_binary_impl(ctx):
    ...
    # ctx.toolchains returns the ToolchainInfo provider directly (not the Target object).
    toolchain_info = ctx.toolchains["//bar_tools:toolchain_type"]
    command = "%s -l %s %s" % (
        toolchain_info.compiler_path,
        toolchain_info.system_lib,
        " ".join(toolchain_info.arch_flags),
    )
    ...

... # Omitting definition of bar_binary rule.
```

It may be debatable whether or not wrapping all toolchain-conveyed information explicitly in a `ToolchainInfo` results in a better user experience for toolchain rule authors and consumers. On the one hand, it's an extra step and introduces a visible difference in the amount of info available via toolchain dependence vs regular dependence. On the other hand, it makes the set of toolchain-visible info more explicit, and is preferred for implementation reasons as well (it avoids proliferating arbitrary inspection of configured targets to list all their providers). Regardless, this doc assumes that `ToolchainInfo` will remain the means of propagating information through the toolchain framework.

Rather, this doc addresses the schema of `ToolchainInfo`. At the moment it is semi-structured, with no guarantee that toolchains return objects with specific fields or values. Any discrepancies will likely lead to an analysis failure dynamically, at the point where an illegal operation is performed, due to a missing field or wrong type of value in a field.

## Option 1: Flat namespace with arbitrary string keys

This is the status quo. It's similar to how you can return legacy-style providers using the `struct` syntax.

```python
    # _bar_toolchain_impl()
    ...
    toolchain_info = ToolchainInfo(
        compiler_path = "/usr/bin/gcc",
        compiler_arch_flags = ["--foo"],
        linker_path = "/usr/bin/ld",
        linker_arch_flags = ["--bar"],
    )
    ...

    # _bar_binary_impl()
    ...
    toolchain_info = ctx.toolchains["//bar_tools:toolchain_type"]
    compiler_path = toolchain_info.compiler_path
    ...
```

**Pros:**
- Straightforward, relatively concise.

**Cons:**
- Top-level keys share a namespace, so keys from unrelated features might clash. E.g. `compiler_path` and `linker_path` are qualified by the tool because they can't both be `path`.
- Schema is free-form; toolchain rules and consuming rules must agree on field layout, no eager validation.

## Option 2: One field per provider

This is a convention recommendation: Group values by their logical provider, and return these providers as the top-level fields of the `ToolchainInfo`.

```python
    # _bar_toolchain_impl()
    ...
    toolchain_info = ToolchainInfo(
        compiler_info = CompilerInfo(
            path = "/usr/bin/gcc",
            arch_flags = ["--foo"],
        ),
        linker_info = LinkerInfo(
            path = "/usr/bin/ld",
            arch_flags = ["--bar"],
        ),
    )
    ...

    # _bar_binary_impl()
    ...
    toolchain_info = ctx.toolchains["//bar_tools:toolchain_type"]
    compiler_path = toolchain_info.compiler_info.path
    ...
```

**Pros:**
- API consistency: adheres to the convention that the atomic unit of information is a provider instance, same as you'd get from depending on the target directly.
- Helper functions that operate on provider instances will work as-is.
- Although field names are still loose (though we'd recommend keeping them the same as the provider name), field values are subject to whatever schema requirements the provider type has (allowed fields, their types, their docstrings).

**Cons:**
- More verbose.
- User must repeat the provider name as the field name.

# Option 3: Provider-keyed collection

Have `ToolchainInfo` take in a list of provider instances instead of key-value pairs. Provider instances are retrieved from a `ToolchainInfo` object by keying on the provider type. Deprecate and migrate the old struct-like construction and retrievals from `ToolchainInfo`.

```python
    # _bar_toolchain_impl()
    ...
    toolchain_info = ToolchainInfo([
        CompilerInfo(
            path = "/usr/bin/gcc",
            arch_flags = ["--foo"],
        ),
        LinkerInfo(
            path = "/usr/bin/ld",
            arch_flags = ["--bar"],
        ),
    ])
    ...

    # _bar_binary_impl()
    ...
    toolchain_info = ctx.toolchains["//bar_tools:toolchain_type"]
    compiler_path = toolchain_info[CompilerInfo].path
    ...
```

Pros:
- Analogous to how modern declared/symbolic providers are returned and retrieved for ordinary dependencies.
- No need to agree on extra field names besides those already covered by a provider's own schema.
- If toolchain types get the ability to declare advertised/required providers, `ToolchainInfo` objects can be easily validated against these requirements.
