[
    py_test(
        name = "benchmark_test_" + test_file.replace(".", "_"),
        srcs = [
            "benchmark_test.py",
            "testenv.py",
        ],
        args = [
            test_file,
        ],
        data = [
            test_file,
            "@io_bazel//src/main/java/com/google/devtools/starlark:Starlark",
            "@net_starlark_go//cmd/starlark:starlark",
            "@starlark-rust//:starlark",
        ],
        main = "benchmark_test.py",
        tags = ["exclusive"],
    )
    for test_file in glob(["data/*"])
]
