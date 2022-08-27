import spec_md_gen_lib


def main():
    spec_md = spec_md_gen_lib.gen_spec_md()
    print(spec_md, end="", file=open("spec.md", mode="w", encoding="utf-8"))


if __name__ == "__main__":
    main()
