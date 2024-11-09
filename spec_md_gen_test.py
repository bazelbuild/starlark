import spec_md_gen_lib

expected = spec_md_gen_lib.gen_spec_md()
actual = open("spec.md", mode="r", encoding="utf-8").read()
assert expected == actual
