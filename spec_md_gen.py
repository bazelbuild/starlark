import spec_md_gen_lib


def main():
    spec_md = spec_md_gen_lib.gen_spec_md()
    with open("spec.md", mode="w", encoding="utf-8") as f:
        print(spec_md, end="", file=f)


if __name__ == "__main__":
    main()
