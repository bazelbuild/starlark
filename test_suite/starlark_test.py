import sys
import unittest
import tempfile
import subprocess
import os
import re
import glob

import testenv

class StarlarkTest(unittest.TestCase):
  CHUNK_SEP = "---"
  ERR_SEP = "###"
  seen_error = False

  def chunks(self, path):
    code = []
    expected_errors = []
    with open(path, mode="rb") as f:
      for line in f:
        line = line.decode("utf-8")
        if line.strip() == self.CHUNK_SEP:
          yield code, expected_errors
          expected_errors = []
          code = []
        else:
          code.append(line)
          i = line.find(self.ERR_SEP)
          if i >= 0:
            expected_errors.append(line[i + len(self.ERR_SEP):].strip())
    yield code, expected_errors

  def evaluate(self, f):
    """Execute Starlark file, return stderr."""
    proc = subprocess.Popen(
        [binary_path, f], stderr=subprocess.PIPE, stdout=subprocess.PIPE)
    _, stderr = proc.communicate()
    return stderr

  def check_output(self, output, expected):
    if expected and not output:
      self.seen_error = True
      print("Expected error:", expected)

    if output and not expected:
      self.seen_error = True
      print("Unexpected error:", output)

    output_ = output.lower()
    for exp in expected:
      exp = exp.lower()
      # Try both substring and regex matching.
      if exp not in output_ and not re.search(exp, output_):
        self.seen_error = True
        print("Error `{}` not found, got: `{}`".format(exp, output))

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
    print("===", test_file, "===")
    f = os.path.join(testenv.STARLARK_TESTDATA_PATH, test_file)
    for chunk, expected in self.chunks(f):
      with tempfile.NamedTemporaryFile(
          mode="wb", suffix=".star", delete=False) as tmp:
        lines = [line.encode("utf-8") for line in
                 [self.PRELUDE] + chunk]
        tmp.writelines(lines)
      output = self.evaluate(tmp.name).decode("utf-8")
      os.unlink(tmp.name)
      self.check_output(output, expected)
    if self.seen_error:
      raise Exception("Test failed")
    pass

if __name__ == "__main__":
  # Test filename is the last argument on the command-line.
  test_file = sys.argv[-1]
  binary_path = glob.glob(testenv.STARLARK_BINARY_PATH[sys.argv[-2]])[0]
  unittest.main(argv=sys.argv[2:])
