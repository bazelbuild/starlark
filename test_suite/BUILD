load("@rules_python//python:defs.bzl", "py_test")
load(":util.bzl", "format_test_name")

# Java Starlark interpreter jar, vendored into this repo.
# See https://github.com/bazelbuild/bazel/issues/25480 for removing the
# vendoring.
java_import(
    name = "java_starlark_jar",
    jars = [":starlark_deploy.jar"],
)

# Java Starlark interpreter.
java_binary(
    name = "java_starlark",
    runtime_deps = [":java_starlark_jar"],
    main_class = "net.starlark.java.cmd.Main",
)

# TODO(#305): Our dependency on the other interpreters is broken.
#
# Go Starlark interpreter.
# alias(
#     name = "go_starlark",
#     actual = "@net_starlark_go//cmd/starlark:starlark",
# )
#
# # Rust Starlark interpreter.
# alias(
#     name = "rust_starlark",
#     actual = "@starlark-rust//:starlark",
# )

# Creates //test_suite/starlark_<IMPL>_test_testdata_<IMPL>_<TESTNAME>_star targets.
[
    py_test(
        name = format_test_name(impl_name, test_file),
        srcs = [
            "starlark_test.py",
        ],
        args = [
            impl_name,
            "$(location %s)" % impl_target,
            "$(location %s)" % test_file,
        ],
        data = [
            impl_target,
            test_file,
        ],
        main = "starlark_test.py",
    )
    for test_file in glob([
        "testdata/java/*",
        "testdata/go/*",
        "testdata/rust/*"
    ], exclude = ["**/.*"])
    for impl_name, impl_target in [
        ("java", ":java_starlark"),
        # TODO(#305): Broken.
        # ("go", ":go_starlark"),
        # ("rust", ":rust_starlark"),
    ]
]
