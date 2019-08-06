import sys
import unittest
import subprocess
import os
import glob
import statistics
import signal

import testenv

class BenchmarkTest(unittest.TestCase):

  NUM_ITERATIONS = 5
  TIMEOUT = 20
  active_process = None

  class BenchmarkResults:
    def __init__(self, title, rusage_list):
      self.ru = rusage_list
      self._title = title

    @property
    def title(self):
      return self._title

    @title.setter
    def title(self, title):
      self.title_ = title

    @property
    def time(self):
      if hasattr(self, "_time"):
        return self._time
      self._time = statistics.median([float(t.ru_utime + t.ru_stime) for t in self.ru]) * 1000.0
      return self._time

    @property
    def memory(self):
      if hasattr(self, "_memory"):
        return self._memory
      self._memory = statistics.median([float(m.ru_maxrss) for m in self.ru])
      if sys.platform == 'darwin':
        self._memory /= 1024.0
      return self._memory


  def benchmark(self, f, binary):
    """Execute Starlark file, return benchmark results and stderr."""
    ru = []
    stderr = None
    for _ in range(self.NUM_ITERATIONS):
      self.active_process = subprocess.Popen(
        [glob.glob(testenv.STARLARK_BINARY_PATH[binary])[0], f],
         stderr=subprocess.PIPE, stdout=subprocess.PIPE)

      # Set timeout alarm
      signal.alarm(self.TIMEOUT)
      ru.append(os.wait4(self.active_process.pid, 0)[2])
      _, stderr = self.active_process.communicate()
      signal.alarm(0)
    return self.BenchmarkResults(binary, ru), stderr

  def check_output(self, output):
    """Any line in stderr that doesn't start with ### is
       considered an error and the test fails"""
    error = []
    for line in output.splitlines():
      if not line.startswith('###'):
        error.append(line)
    if len(error) != 0:
      print("Unexpected:\n" + '\n'.join(error[:20] + ['...']))
      raise Exception("Test failed")

  def get_max_width(self, table, index):
    """Get the maximum width of the given column index"""
    return max([len(str(row[index])) for row in table])

  def display_table(self, table):
    """Pretty prints the results table"""
    col_paddings = []
    for i in range(len(table[0])):
      col_paddings.append(self.get_max_width(table, i))

    for row in table:
      # left col
      print(row[0].ljust(col_paddings[0] + 1), end='')
      # rest of the cols
      for i in range(1, len(row)):
        if isinstance(row[i], float):
          row[i] = "{0:.3f}".format(row[i])
        col = str(row[i]).rjust(col_paddings[i] + 2)
        print(col, end='')
      print()
    print("\n* A timeout happens if a process hasn't terminated after %d seconds." % self.TIMEOUT)

  def handler(self, signum, frame):
    raise Exception()

  def testFile(self):
    print("===", test_file, "===")
    f = os.path.join(testenv.STARLARK_TESTDATA_PATH, test_file)
    signal.signal(signal.SIGALRM, self.handler)

    results = []
    for binary in testenv.STARLARK_BINARY_PATH:
      try:
        result_, out = self.benchmark(f, binary)
      except Exception:
        if self.active_process is not None:
          self.active_process.kill()
          # cleans up stdout, stderr after process termination
          self.active_process.communicate()
          self.active_process = None
        results.append(binary)
        continue

      results.append(result_)
      self.check_output(out.decode("utf-8"))

    table = [["", "Time (MS)", "Memory (KB)"]]
    for res in results:
      if isinstance(res, str):
        table.append([res, "Timeout*", "Timeout*"])
      else:
        table.append([res.title, res.time, res.memory])
    self.display_table(table)

if __name__ == "__main__":
  # Test filename is the last argument on the command-line.
  test_file = sys.argv[-1]
  unittest.main(argv=sys.argv[1:])
