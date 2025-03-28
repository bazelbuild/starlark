import re


# Generate `spec.md` file.
def gen_spec_md() -> str:
  # State is either:
  # - reading spec.md before TOC
  # - reading (and ignoring) TOC
  # - reading spec.md after TOC
  state = "BEFORE_TOC"

  before_toc = []
  toc = []
  after_toc = []

  for line in open("spec.md", mode="r", encoding="utf-8").readlines():
    line = line.rstrip()

    if state == "BEFORE_TOC":
      before_toc += [line]

    heading = line.startswith("##") and not line.startswith("####")
    heading_contents = line == "## Contents"

    if heading_contents:
      assert state == "BEFORE_TOC"
      state = "TOC"

    if heading:
      # Convert heading to TOC entry.
      level = len(re.sub("[^#]", "", line))
      title = re.sub("^#+\s*", "", line)
      link = re.sub(" ", "-", title.lower())
      toc += [f" {(level - 2) * 2 * ' '} * [{title}](#{link})"]

    if heading and state == "TOC" and not heading_contents:
      state = "AFTER_TOC"

    if state == "AFTER_TOC":
      after_toc += [line]

  assert state == "AFTER_TOC"
  lines = before_toc + [""] + toc + [""] + after_toc

  return "".join([line + "\n" for line in lines])
