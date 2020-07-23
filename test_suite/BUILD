load("@rules_python//python:defs.bzl", "py_test")

[
    [
        py_test(
            name = "starlark_" + impl + "_test_" + test_file.replace(".", "_"),
            srcs = [
                "starlark_test.py",
                "testenv.py",
            ],
            args = [
                impl,
                test_file,
            ],
            data = [
                binary_rule,
                test_file,
            ],
            main = "starlark_test.py",
        )
        for test_file in glob(["testdata/java/*", "testdata/go/*", "testdata/rust/*"])
    ]
    for impl, binary_rule in [("java", "@io_bazel//src/main/java/net/starlark/java/cmd:Starlark"),
                              ("go", "@net_starlark_go//cmd/starlark:starlark"),
                              ("rust", "@starlark-rust//:starlark")]
]
