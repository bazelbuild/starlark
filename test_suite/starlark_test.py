import sys
import typing
import unittest
import tempfile
import subprocess
import os
import re
import glob

def indent(s: str) -> str:
  return "".join("  " + line.rstrip("\n") + "\n" for line in s.splitlines())

class StarlarkTest(unittest.TestCase):
  CHUNK_SEP = "---"
  seen_error = False

  def chunks(self, path) -> typing.Iterable[typing.Tuple[typing.List[str], typing.List[str], int]]:
    code = []
    expected_errors = []
    # Current line no
    line_no = 0
    # Current test first line no
    test_line_no = 1
    with open(path, mode="rb") as f:
      for line in f:
        line_no += 1
        line = line.decode("utf-8").rstrip()
        if line == self.CHUNK_SEP:
          yield code, expected_errors, test_line_no
          expected_errors = []
          code = []
          test_line_no = line_no + 1
        else:
          m = re.fullmatch("(.*?) *### *((go|java|rust):)? *(.*)", line)
          if m:
            error_impl = m.group(3)
            assert error_impl is None or error_impl in ["go", "java", "rust"]
            if (not error_impl) or error_impl == impl:
              expected_errors.append(m.group(4))
            code.append(m.group(1))
          else:
            code.append(line)
          code.append("\n")
    assert len(expected_errors) <= 1
    yield code, expected_errors, test_line_no

  def evaluate(self, f):
    """Execute Starlark file, return stderr."""
    proc = subprocess.Popen(
        [binary_path, f], stderr=subprocess.PIPE, stdout=subprocess.PIPE)
    stdout, stderr = proc.communicate()
    if proc.returncode == 0:
      return b""
    else:
      return stdout + stderr

  def mark_error(self):
    if self.seen_error:
      print()
    self.seen_error = True

  def check_output(self, output, expected, line_no):
    if expected and not output:
      self.mark_error()
      print("Test L{}: expected error: {}".format(line_no, expected))

    if output and not expected:
      self.mark_error()
      print("Test L{}: unexpected error: {}".format(line_no, output))

    output_ = output.lower()
    for exp in expected:
      exp = exp.lower()
      # Try both substring and regex matching.
      # TODO(stepancheg): error messages are checked incorrectly on rust,
      #   because error message contains source snippet.
      #   Fix it by removing `###` before evaluating.
      if exp not in output_ and not re.search(exp, output_):
        self.mark_error()
        print("Test L{}: error not found: `{}`".format(line_no, exp.encode('utf-8')))
        print("Got:")
        print(indent(output), end="")

  PRELUDE = """
def assert_eq(x, y):
  if x != y:
    print("%r != %r" % (x, y))

def assert_ne(x, y):
  if x == y:
    print("%r == %r" % (x, y))

def assert_(cond, msg="assertion failed"):
  if not cond:
    print(msg)
"""

  def testFile(self):
    print("=== {} with {} ===".format(test_file, impl))
    for chunk, expected, line_no in self.chunks(test_file):
      with tempfile.NamedTemporaryFile(
          mode="wb", suffix=".star", delete=False) as tmp:
        lines = [line.encode("utf-8") for line in
                 [self.PRELUDE] + chunk]
        tmp.writelines(lines)
      output = self.evaluate(tmp.name).decode("utf-8")
      os.unlink(tmp.name)
      self.check_output(output, expected, line_no)
    if self.seen_error:
      raise Exception("Test failed")
    pass

if __name__ == "__main__":
  # <test args...> <"java"|"go"|"rust"> <path to interpreter> <path to Starlark file>
  impl = sys.argv[-3]
  binary_path = sys.argv[-2]
  test_file = sys.argv[-1]
  unittest.main(argv=sys.argv[:-3])
