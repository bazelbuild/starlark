load("@rules_python//python:defs.bzl", "py_binary", "py_test")

py_binary(
    name = "spec_md_gen",
    srcs = ["spec_md_gen.py", "spec_md_gen_lib.py"],
    data = ["spec.md"],
)

py_test(
    name = "spec_md_gen_test",
    srcs = ["spec_md_gen_test.py", "spec_md_gen_lib.py"],
    data = ["spec.md"],
)
