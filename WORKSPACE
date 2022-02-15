workspace(name = "starlark_test_suite")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")

http_archive(
    name = "rules_cc",
    sha256 = "36fa66d4d49debd71d05fba55c1353b522e8caef4a20f8080a3d17cdda001d89",
    strip_prefix = "rules_cc-0d5f3f2768c6ca2faca0079a997a97ce22997a0c",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_cc/archive/0d5f3f2768c6ca2faca0079a997a97ce22997a0c.zip",
        "https://github.com/bazelbuild/rules_cc/archive/0d5f3f2768c6ca2faca0079a997a97ce22997a0c.zip",
    ],
)

git_repository(
    name = "rules_python",
    remote = "https://github.com/bazelbuild/rules_python.git",
    commit = "4b84ad270387a7c439ebdccfd530e2339601ef27",  # 2019-08-02
)

load("@rules_python//python:repositories.bzl", "py_repositories")
py_repositories()

http_archive(
    name = "rules_proto",
    sha256 = "88b0a90433866b44bb4450d4c30bc5738b8c4f9c9ba14e9661deb123f56a833d",
    strip_prefix = "rules_proto-b0cc14be5da05168b01db282fe93bdf17aa2b9f4",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_proto/archive/b0cc14be5da05168b01db282fe93bdf17aa2b9f4.tar.gz",
        "https://github.com/bazelbuild/rules_proto/archive/b0cc14be5da05168b01db282fe93bdf17aa2b9f4.tar.gz",
    ],
)

http_archive(
    name = "rules_pkg",
    sha256 = "5bdc04987af79bd27bc5b00fe30f59a858f77ffa0bd2d8143d5b31ad8b1bd71c",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/rules_pkg-0.2.0.tar.gz",
        "https://github.com/bazelbuild/rules_pkg/releases/download/0.2.0/rules_pkg-0.2.0.tar.gz",
    ],
)
load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")
rules_pkg_dependencies()

git_repository(
    name = "io_bazel",
    remote = "https://github.com/bazelbuild/bazel.git",
    commit = "69a2f92c7a98e25f70c90a84742d12ea46c7a3b4", # 2021-07-09
)

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "8e968b5fcea1d2d64071872b12737bbb5514524ee5f0a4f54f5920266c261acb",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.28.0/rules_go-v0.28.0.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.28.0/rules_go-v0.28.0.zip",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "62ca106be173579c0a167deb23358fdfe71ffa1e4cfdddf5582af26520f1c66f",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.23.0/bazel-gazelle-v0.23.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.23.0/bazel-gazelle-v0.23.0.tar.gz",
    ],
)
load("@io_bazel_rules_go//go:deps.bzl", "go_rules_dependencies", "go_register_toolchains")
go_rules_dependencies()
go_register_toolchains(version = "1.16.5")
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
  remote = "https://github.com/facebookexperimental/starlark-rust.git",
  branch = "main",
  build_file_content = """
genrule(
    name = "starlark",
    outs = ["target/debug/starlark-repl"],
    srcs = ["."],
    cmd = "cd $(SRCS) && cargo build && cd - && cp $(SRCS)/target/debug/starlark $@",
    executable = True,
    local = True,
    visibility = ["//visibility:public"],
)
"""
)
