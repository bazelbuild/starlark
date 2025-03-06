import sys
from difflib import unified_diff
import spec_md_gen_lib

if __name__ == "__main__":
    actual = open("spec.md", mode="r", encoding="utf-8").read().split("\n")
    expected = spec_md_gen_lib.gen_spec_md().split("\n")
    if expected != actual:
        print("Failed!\n")
        diff = unified_diff(actual, expected, fromfile='spec.md', tofile='<generated>', n=10)
        for line in diff:
            print(line)
        sys.exit(1)
