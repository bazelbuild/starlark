workspace(name = "starlark_test_suite")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")

git_repository(
    name = "io_bazel",
    remote = "https://github.com/bazelbuild/bazel.git",
    branch = "master",
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "io_bazel_rules_go",
    urls = ["https://github.com/bazelbuild/rules_go/releases/download/0.18.5/rules_go-0.18.5.tar.gz"],
    sha256 = "a82a352bffae6bee4e95f68a8d80a70e87f42c4741e6a448bec11998fcc82329",
)

http_archive(
    name = "bazel_gazelle",
    urls = ["https://github.com/bazelbuild/bazel-gazelle/releases/download/0.17.0/bazel-gazelle-0.17.0.tar.gz"],
    sha256 = "3c681998538231a2d24d0c07ed5a7658cb72bfb5fd4bf9911157c0e9ac6a2687",
)
load("@io_bazel_rules_go//go:deps.bzl", "go_rules_dependencies", "go_register_toolchains")
go_rules_dependencies()
go_register_toolchains()
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")
gazelle_dependencies()
load("@bazel_gazelle//:deps.bzl", "go_repository")

go_repository(
    name = "net_starlark_go",
    importpath = "go.starlark.net",
    tag = "master",
)

# Import dependency for starlark-go
go_repository(
    name = "com_github_chzyer_readline",
    importpath = "github.com/chzyer/readline",
    tag = "master",
)

# Assumes you have cargo/rust installed
new_git_repository(
  name = "starlark-rust",
  remote = "https://github.com/google/starlark-rust.git",
  branch = "master",
  build_file_content = """
genrule(
    name = "starlark",
    outs = ["target/debug/starlark-repl"],
    srcs = ["."],
    cmd = "cd $(SRCS) && cargo build && cd - && cp $(SRCS)/target/debug/starlark-repl $@",
    executable = True,
    local = True,
    visibility = ["//visibility:public"],
)
"""
)
