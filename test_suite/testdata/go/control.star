# Tests of Starlark control flow


def controlflow():
  # elif
  x = 0

  if True:
    x=1
  elif False:
    fail("else of true")
  else:
    fail("else of else of true")
  assert_(x)

  x = 0
  if False:
    fail("then of false")
  elif True:
    x = 1
  else:
    fail("else of true")
  assert_(x)

  x = 0
  if False:
    fail("then of false")
  elif False:
    fail("then of false")
  else:
    x = 1
  assert_(x)
controlflow()

def loops():
  y = ""
  for x in [1, 2, 3, 4, 5]:
    if x == 2:
      continue
    if x == 4:
      break
    y = y + str(x)
  return y
assert_eq(loops(), "13")

# return
g = 123
def f(x):
  for g in (1, 2, 3):
    if g == x:
      return g
assert_eq(f(2), 2)
assert_eq(f(4), None) # falling off end => return None
assert_eq(g, 123) # unchanged by local use of g in function

# infinite sequences
def fib(n):
  seq = []
  x = 0
  y = 1
  for i in range(n):
    if len(seq) == n:
      break
    seq.append(x)
    x, y = y, x + y
  return seq
assert_eq(fib(10),  [0, 1, 1, 2, 3, 5, 8, 13, 21, 34])
