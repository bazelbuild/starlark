def format_test_name(impl_name, path):
    """Generates a suitable test target name from an implementation name and
    package-relative path under `testdata/`.
    """
    err_msg = (
        "expected test path of form 'testdata/SUITE_NAME/TEST_PATH.star', "
        + "but got '%s'" % path)
    p = path

    if not p.startswith("testdata/"):
        fail(err_msg)
    p = p[len("testdata/"):]

    i = p.find("/")
    if i == -1:
        fail(err_msg)
    suite_name = p[:i]
    p = p[i + 1:]

    if not p.endswith(".star"):
        fail(err_msg)
    p = p[:-len(".star")]

    return "test_%s_impl_with_%s_test_suite__%s" % \
        (impl_name, suite_name, p)
