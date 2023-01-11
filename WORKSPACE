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
    commit = "4b84ad270387a7c439ebdccfd530e2339601ef27",  # 2019-08-02
    remote = "https://github.com/bazelbuild/rules_python.git",
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
    commit = "4853dfd02ac7440a04caada830b7b61b6081bdfe",  # 2023-01-11
    remote = "https://github.com/bazelbuild/bazel.git",
    shallow_since = "1673450740 -0800",
)

http_archive(
    name = "rules_jvm_external",
    sha256 = "b17d7388feb9bfa7f2fa09031b32707df529f26c91ab9e5d909eb1676badd9a6",
    strip_prefix = "rules_jvm_external-4.5",
    url = "https://github.com/bazelbuild/rules_jvm_external/archive/4.5.zip",
)

load("@rules_jvm_external//:repositories.bzl", "rules_jvm_external_deps")

rules_jvm_external_deps()

load("@rules_jvm_external//:setup.bzl", "rules_jvm_external_setup")

rules_jvm_external_setup()

load("@rules_jvm_external//:defs.bzl", "maven_install")

# @io_bazel//src/main/java/net/starlark/java/cmd:starlark dependencies
maven_install(
    artifacts = [
        "com.google.guava:guava:31.1-jre",
        "com.google.errorprone:error_prone_type_annotations:2.16",
        "com.google.code.findbugs:jsr305:3.0.2",
        "com.github.stephenc.jcip:jcip-annotations:1.0-1",
    ],
    repositories = [
        "https://dl.google.com/android/maven2",
        "https://repo1.maven.org/maven2",
    ],
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
""",
    remote = "https://github.com/facebookexperimental/starlark-rust.git",
)
