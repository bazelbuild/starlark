import sys
import unittest

import testenv

class StarlarkTest(unittest.TestCase):
    pass

if __name__ == "__main__":
  # Test filename is the last argument on the command-line.
  test_file = sys.argv[-1]
  binary_path = testenv.STARLARK_BINARY_PATH[sys.argv[-2]]
  unittest.main(argv=sys.argv[2:])
