<nbsp>|<nbsp>
---|---
status | draft
created | 2018-08-17
updated | 2018-08-17
author(s) | [brandjon@](https://github.com/brandjon)
reviewer(s) | Starlark core reviewers
discussion thread | [#2](https://github.com/bazelbuild/starlark/issues/2)

# Genrule-setup for Starlark

## Abstract

This doc proposes adding `genrule-setup.sh` as a hook for customizing how shell commands are executed in custom rules. An alternative is also presented that avoids the hook but still makes shell commands for custom rules more strict.

## Background

[Genrule](https://docs.bazel.build/versions/master/be/general.html#genrule) is a built-in rule for executing arbitrary shell commands. It is a simpler alternative to defining a custom rule in a bzl file, and is particularly useful for one-off targets.

The script [`//tools/genrule/genrule-setup.sh`](https://github.com/bazelbuild/bazel/blob/0.16.1/tools/genrule/genrule-setup.sh) is an implicit dependency of [all genrules](https://github.com/bazelbuild/bazel/blob/0.16.1/src/main/java/com/google/devtools/build/lib/bazel/rules/genrule/BazelGenRuleRule.java#L51). This script is [sourced](https://github.com/bazelbuild/bazel/blob/0.16.1/src/main/java/com/google/devtools/build/lib/rules/genrule/GenRuleBase.java#L167) to initialize the shell in which the genrule command runs. Users can override `//tools/genrule/genrule-setup.sh` in their workspace to customize their shell environments, e.g. for better sandboxing. But by default, it simply sets -euo pipefail to make shell commands fail-fast more often.

The `genrule-setup.sh` script is *not* consulted for [`ctx.actions.run_shell()`](https://docs.bazel.build/versions/master/skylark/lib/actions.html#run_shell) actions in a custom rule. This means that these shell actions do not benefit from fail-fast behavior, nor any additional shell environment customization that is done for the workspace's genrules (sandboxing). The rule author can still add these behaviors by prepending them to the shell command, but this

1.  is burdensome and error-prone,
1.  is verbose, relative to the typical size of a `run_shell()` command (often one-liners like touch, cp, and mv), and
1.  does not allow injection of shell customization by the workspace.

Fail-fast behavior would be particularly applicable to `run_shell()` commands, since they often refer to arguments via `$1`, `$2`, etc., which by default silently expand to the empty string when there is an argument mismatch.

The [documentation](https://docs.bazel.build/versions/master/skylark/lib/actions.html#run_shell.command) for `run_shell()` says it uses the same shell as genrule, which is at best a half-truth since the shell configuration is different. Any design change here should also bring the documentation up-to-date.

## Proposal

### Option 1: Source genrule-setup.sh

This proposal has `run_shell()` actions source the `genrule-setup.sh` script, so that the shell is configured in the same way as for genrules. This would only apply to `run_shell()` invocations where the [`command` argument is a string](https://github.com/bazelbuild/bazel/blob/0.16.1/src/main/java/com/google/devtools/build/lib/analysis/skylark/SkylarkActionFactory.java#L272), since in that case we can easily change the existing transformation

```
sh -c '<cmd>'
```

into

```
sh -c 'source <path to genrule-setup.sh>; <cmd>'
```

without modifying the underlying `SpawnAction.Builder` logic. It would not apply to invocations where the [`command` argument is a list of strings](https://github.com/bazelbuild/bazel/blob/0.16.1/src/main/java/com/google/devtools/build/lib/analysis/skylark/SkylarkActionFactory.java#L291)</code>; this form is deprecated anyway.

Since the contents of `genrule-setup.sh` are applied inside the command, they take precedence over other environment variables, such as those specified by `run_shell()`'s [`env`](https://docs.bazel.build/versions/master/skylark/lib/actions.html#run_shell.env) parameter.

[`ctx.action.run()`](https://docs.bazel.build/versions/master/skylark/lib/actions.html#run) is unaffected by this change. It would still be possible (though questionable) to run a shell that bypasses `genrule-setup.sh` by doing

```
ctx.actions.run(executable=<path to shell>, arguments = ["-c", "<cmd>"], ...)
```

#### Caveats

In order for this proposal to work, `genrule-setup.sh` must be made an input to `run_shell()` invocations that use a string value for the `command` argument. To facilitate doing this automatically, we make the script an implicit input (just like for genrules) of all rules containing such a call. Since Bazel is not in the business of analyzing the dynamic behavior of Starlark code, in practice this means that `genrule-setup.sh` must be an implicit input of all Starlark rules. This may have memory implications for large builds.

There is a fragmentation hazard associated with encouraging more widespread use of `genrule-setup.sh`: Any repo whose shell commands (whether `run_shell()` or genrule) rely on custom setup for their semantics may become incompatible with other repos. A best practice would be to use `genrule-setup.sh` only for configuration that should not affect semantics (e.g., sandboxing). All reusable build rules should be designed to assume only that `genrule-setup.sh` does set -euo pipefail.

### Option 2: Set -euo pipefail

This alternative works as above, except that

```
source <path to genrule-setup.sh>
```

is replaced by a simple literal

```
set -euo pipefail
```

That is, `run_shell()` actions get the fail-fast behavior, but do not get the custom behavior injected by the workspace.

No extra implicit input is needed. There is no fragmentation hazard. There is no easy mechanism for users to add sandboxing.

## Backward-compatibility

Both alternatives change the behavior of `run_shell()` for the (non-deprecated) case where `command` is a string. Option 1 adds arbitrary setup specified by the workspace, including possibly environment variables that override those specified by the `env` parameter. Option 2 may make some builds fail that previously succeeded (albeit with failing shell actions). For workspaces that do not override `genrule-setup.sh`, both options are equivalent.

For Option 1, rollout will be controlled by a flag, e.g. "`--incompatible_run_shell_uses_genrule_setup`". This allows a workspace that depends on `genrule-setup.sh` for genrules to temporarily opt out of also applying it to `run_shell()`. Alternatively, workspaces that do not care about the setup for genrules can replace `//tools/genrule/genrule-setup.sh` with an empty file. Although this workaround will work indefinitely, it perpetuates the bad practice of relying on the custom `genrule-setup.sh` and may be incompatible with other repos.

For Option 2, rollout will be controlled only by a flag, e.g. "`--incompatible_shell_actions_fail_fast`".
