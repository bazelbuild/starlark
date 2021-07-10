# Tests of Starlark 'function'

def outer(): pass
def inner(): pass
z = inner

# Function name
assert_eq(str(outer), '<function outer>')
assert_eq(str(z), '<function inner>')
assert_eq(str(str), '<built-in function str>')

# Stateful closure
def sq(x):
    x[0] += 1
    return x[0] * x[0]

x = [0]
assert_eq(sq(x), 1)
assert_eq(sq(x), 4)
assert_eq(sq(x), 9)
assert_eq(sq(x), 16)

# recursion detection, simple
def fib(x):
  if x < 2:
    return x
  return fib(x-2) + fib(x-1)
# _inconsistency_: rust fails to detect recursion
# fib(10) ## (recursive|Recursion was detected)
---

# _inconsistency_: java does not support lambda
# recursion detection, advanced
#
# A simplistic recursion check that looks for repeated calls to the
# same function value will not detect recursion using the Y
# combinator, which creates a new closure at each step of the
# recursion.  To truly prohibit recursion, the dynamic check must look
# for repeated calls of the same syntactic function body.
#Y = lambda f: (lambda x: x(x))(lambda y: f(lambda *args: y(y)(*args)))
#fibgen = lambda fib: lambda x: (x if x<2 else fib(x-1)+fib(x-2))
#fib2 = Y(fibgen)
#[fib2(x) for x in range(10)] ## function lambda called recursively



# However, this stricter check outlaws many useful programs
# that are still bounded, and creates a hazard because
# helper functions such as map below cannot be used to
# call functions that themselves use map:
def map(f, seq): return [f(x) for x in seq]
def double(x): return x+x
assert_eq(map(double, [1, 2, 3]), [2, 4, 6])
assert_eq(map(double, ["a", "b", "c"]), ["aa", "bb", "cc"])
def mapdouble(x): return map(double, x)
# _inconsistency_: rust fails to detect recursion
# map(mapdouble, ([1, 2, 3], ["a", "b", "c"])) ## (recursive|Recursion was detected)
# With the -recursion option it would yield [[2, 4, 6], ["aa", "bb", "cc"]].
---

# _inconsistency_: java does not support lambda
# call of function not through its name
#def f():
#   return lambda: 1
#assert_eq(f()(), 1)

assert_eq(["abc"][0][0].upper(), "A")

# functions may be recursively defined,
# so long as they don't dynamically recur.
calls = []
def yin(x):
  calls.append("yin")
  if x:
    yang(False)

def yang(x):
  calls.append("yang")
  if x:
    yin(False)

yin(True)
assert_eq(calls, ["yin", "yang"])

---
calls = []

def yin(x):
  calls.append("yin")
  if x:
    yang(False)

def yang(x):
  calls.append("yang")
  if x:
    yin(False)

yang(True)
assert_eq(calls, ["yang", "yin"])


# builtin_function_or_method use identity equivalence.
closures = [str for _ in range(10)]
assert_eq(len(closures), 10)

---
# Default values of function parameters are mutable.

def f(x=[0]):
  return x

assert_eq(f(), [0])

f().append(1)
assert_eq(f(), [0, 1])


---

def f(x):
  return 1 if x else 0

assert_eq(f(True), 1)
assert_eq(f(False), 0)

def f2_(x):
  return 1

x = True
f2 = (f2_) if x else 0
assert_eq(f2(123), 1)

def f_1(): return True
def f_2(): return False
tf = f_1, f_2
assert_(tf[0]())
assert_(not tf[1]())

---
# Missing parameters are correctly reported
# in functions of more than 64 parameters.
# (This tests a corner case of the implementation:
# we avoid a map allocation for <64 parameters)

def f(a, b, c, d, e, f, g, h,
      i, j, k, l, m, n, o, p,
      q, r, s, t, u, v, w, x,
      y, z, A, B, C, D, E, F,
      G, H, I, J, K, L, M, N,
      O, P, Q, R, S, T, U, V,
      W, X, Y, Z, aa, bb, cc, dd,
      ee, ff, gg, hh, ii, jj, kk, ll,
      mm):
  pass

f(
    1, 2, 3, 4, 5, 6, 7, 8,
    9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, 21, 22, 23, 24,
    25, 26, 27, 28, 29, 30, 31, 32,
    33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48,
    49, 50, 51, 52, 53, 54, 55, 56,
    57, 58, 59, 60, 61, 62, 63, 64) ### (missing 1 .*argument|not enough parameters|missing parameter)
---
def f(a, b, c, d, e, f, g, h,
      i, j, k, l, m, n, o, p,
      q, r, s, t, u, v, w, x,
      y, z, A, B, C, D, E, F,
      G, H, I, J, K, L, M, N,
      O, P, Q, R, S, T, U, V,
      W, X, Y, Z, aa, bb, cc, dd,
      ee, ff, gg, hh, ii, jj, kk, ll,
      mm):
  pass

f(
    1, 2, 3, 4, 5, 6, 7, 8,
    9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, 21, 22, 23, 24,
    25, 26, 27, 28, 29, 30, 31, 32,
    33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48,
    49, 50, 51, 52, 53, 54, 55, 56,
    57, 58, 59, 60, 61, 62, 63, 64, 65,
    mm = 100) ### (multiple values|argument 'mm' passed both by position and by name|Extraneous parameter|occurs both explicitly and in \*\*kwargs)

---
# Regression test for github.com/google/starlark-go/issues/21,
# which concerns dynamic checks.
# Related: https://github.com/bazelbuild/starlark/issues/21,
# which concerns static checks.



def f(*args, **kwargs):
  return args, kwargs

# _inconsistency: rust returns args as list not tuple
# assert_eq(f(x=1, y=2), ((), {"x": 1, "y": 2}))

# _inconsistency_: rust allows duplicate values for kwargs
# f(x=1, **dict(x=2)) ## (multiple values for parameter "x"|duplicate keyword)

---
def g(x, y):
  return x, y

assert_eq(g(1, y=2), (1, 2))

# _inconsistency_: rust allows duplicate values for kwargs
# g(1, y=2, **{'y': 3}) ## (multiple values for parameter "y"|duplicate keyword)

---
# Regression test for a bug in CALL_VAR_KW.


def f(a, b, x, y):
  return a+b+x+y

assert_eq(f(*("a", "b"), **dict(y="y", x="x")) + ".", 'abxy.')
---
# Order of evaluation of function arguments.
# Regression test for github.com/google/skylark/issues/135.


r = []

def id(x):
  r.append(x)
  return x

def f(*args, **kwargs):
  return (args, kwargs)

# _inconsistency_
# This matches Python2, but not Starlark-in-Java:
# *args and *kwargs are evaluated last.
# See github.com/bazelbuild/starlark#13 for pending spec change.

# y = f(id(1), id(2), x=id(3), *[id(4)], y=id(5), **dict(z=id(6)))
# assert_eq(y, ((1, 2, 4), dict(x=3, y=5, z=6)))
# assert_eq(r, [1, 2, 3, 5, 4, 6])


---

def d(x, list):
  list.append(x) # this use of x observes both assignments
def c():
    list = []
    x = 1
    d(x, list)
    x = 2
    d(x, list)
    return list

assert_eq(c(), [1, 2])

def f(x):
  return x # forward reference ok: x is a closure cell
def e():
    x = 1
    return f(x)

assert_eq(e(), 1)

---

def e():
    x = 1
    f()

def f():
  print(x) # this reference to x fails
  x = 3    # because this assignment makes x local to f

e() ### (referenced before assignment|not found)
---

def sum(n):
  r = 0
  for i in range(1000):
    if n <= 0:
      break
    r += n
    n -= 1
  return r

def while_break(n):
  r = 0
  for i in range(1000):
    if n == 5:
      break
    r += n
    n -= 1
  return r

def while_continue(n):
  r = 0
  for i in range(1000):
    if n <= 0:
      break
    if n % 2 == 0:
      n -= 1
      continue
    r += n
    n -= 1
  return r

assert_eq(sum(5), 5+4+3+2+1)
assert_eq(while_break(10), 40)
assert_eq(while_continue(10), 25)
