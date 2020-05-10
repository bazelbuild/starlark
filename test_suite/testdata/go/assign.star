# Tests of Starlark assignment.

# This is a "chunked" file: each "---" effectively starts a new file.

# tuple assignment


a, b, c = 1, 2, 3
assert_eq(a, 1)
assert_eq(b, 2)
assert_eq(c, 3)

---
def f1(): (x,) = 1
f1() ### (int in sequence assignment|not iterable|not a collection)
---
def f2(): a, b, c = 1, 2
f2() ### (too few values to unpack|unpacked 2 values but expected 3|length mismatch)
---
def f3(): a, b = 1, 2, 3
f3() ### (too many values to unpack|unpacked 3 values but expected 2|length mismatch)
---
def f4(): a, b = (1,)
f4() ### (too few values to unpack|unpacked 1 values but expected 2|length mismatch)
---
def f5(): (a,) = [1, 2, 3]
f5() ### (too many values to unpack|unpacked 3 values but expected 1|length mismatch)
---

# list assignment

[a, b, c] = [1, 2, 3]
assert_eq(a, 1)
assert_eq(b, 2)
assert_eq(c, 3)

---
def f1(): [a, b, c,] = 1
f1() ### (got int in sequence assignment|not iterable|not a collection)
---
def f2(): [a, b, c] = 1, 2
f2() ### (too few values to unpack|unpacked 2 values but expected 3|length mismatch)
---
def f3(): [a, b] = 1, 2, 3
f3() ### (too many values to unpack|unpacked 3 values but expected 2|length mismatch)
---
def f4(): [a, b] = (1,)
f4() ### (too few values to unpack|unpacked 1 values but expected 2|length mismatch)
---

# list-tuple assignment

[a, b, c] = (1, 2, 3)
assert_eq(a, 1)
assert_eq(b, 2)
assert_eq(c, 3)

(d, e, f) = [1, 2, 3]
assert_eq(d, 1)
assert_eq(e, 2)
assert_eq(f, 3)

[g, h, (i, j)] = (1, 2, [3, 4])
assert_eq(g, 1)
assert_eq(h, 2)
assert_eq(i, 3)
assert_eq(j, 4)

(k, l, [m, n]) = [1, 2, (3, 4)]
assert_eq(k, 1)
assert_eq(l, 2)
assert_eq(m, 3)
assert_eq(n, 4)

---
# misc assignment

a = [1, 2, 3]
a[1] = 5
assert_eq(a, [1, 5, 3])
a[-2] = 2
assert_eq(a, [1, 2, 3])
assert_eq("%d %d" % (5, 7), "5 7")
x={}
x[1] = 2
x[1] += 3
assert_eq(x[1], 5)
def f12(): x[(1, "abc", {})] = 1
f12() ### (unhashable|not hashable)

---

# augmented assignment

def f():
  x = 1
  x += 1
  assert_eq(x, 2)
  x *= 3
  assert_eq(x, 6)
f()

---

# Top level reassignments aren't allowed

z = 0
z += 3 ### (cannot reassign|augmented assignment|read only)

---

# effects of evaluating LHS occur only once

count = [0] # count[0] is the number of calls to f

def f():
  count[0] += 1
  return count[0]

x = [1, 2, 3]
x[f()] += 1

assert_eq(x, [1, 3, 3]) # sole call to f returned 1
assert_eq(count[0], 1) # f was called only once

---
# Order of evaluation.

calls = []

def f(name, result):
  calls.append(name)
  return result

# The right side is evaluated before the left in an ordinary assignment.
f("array", [0])[f("index", 0)] = f("rhs", 0)
assert_eq(calls, ["rhs", "array", "index"])

calls.pop()
calls.pop()
calls.pop()
f("lhs1", [0])[0], f("lhs2", [0])[0] = f("rhs1", 0), f("rhs2", 0)
assert_eq(calls, ["rhs1", "rhs2", "lhs1", "lhs2"])

# Left side is evaluated first (and only once) in an augmented assignment.
calls.pop()
calls.pop()
calls.pop()
calls.pop()
f("array", [0])[f("index", 0)] += f("addend", 1)
assert_eq(calls, ["array", "index", "addend"])

---
# global referenced before assignment

def f():
   return g ### (referenced before assignment|not found)

f()

g = 1

---
# Free variables are captured by reference, so this is ok.

def f():
   return outer

outer = 1
assert_eq(f(), 1)

---

printok = [False]

# This program should resolve successfully but fail dynamically.
# However, the Java implementation currently reports the dynamic
# error at the x=1 statement (b/33975425).  I think we need to simplify
# the resolver algorithm to what we have implemented.
def use_before_def():
  print(x) # referenced before assignment
  printok[0] = True
  x = 1  # makes 'x' local

use_before_def() ### referenced before assignment
---
# x = [1]
# x.extend([2]) # ok

# _inconsistency_: rust allows this
# def f():
   # x += [4] ## referenced before assignment

# f()

---

z.toUpperCase() ### (global variable z referenced before assignment|not defined|not found|undefined)

---


# It's ok to define a global that shadows a built-in...
list = []
assert_eq(type(list), "list")

# ...but then all uses refer to the global,
# even if they occur before the binding use.
# See github.com/google/skylark/issues/116.
list((1, 2)) ### (invalid call of non-function|not callable|not supported)

---
# Same as above, but set and float are dialect-specific;
# we shouldn't notice any difference.


# float = 1.0
# assert_eq(type(float), "float")

set = [1, 2, 3]
assert_eq(type(set), "list")

# As in Python 2 and Python 3,
# all 'in x' expressions in a comprehension are evaluated
# in the comprehension's lexical block, except the first,
# which is resolved in the outer block.
x = [[1, 2]]
assert_eq([x for x in x for y in x],
          [[1, 2], [1, 2]])

---
# _inconsistency_: rust allows this
# A comprehension establishes a single new lexical block,
# not one per 'for' clause.
# x = [1, 2]
# _ = [x for _ in [3] for x in x] ## local variable x referenced before assignment

---


# assign singleton sequence to 1-tuple
(x,) = (1,)
assert_eq(x, 1)
(y,) = [1]
assert_eq(y, 1)

# assign 1-tuple to variable
z = (1,)
assert_eq(type(z), "tuple")
assert_eq(len(z), 1)
assert_eq(z[0], 1)

# assign value to parenthesized variable
(a) = 1
assert_eq(a, 1)

---
# assignment to/from fields.
# load("assert.star", "assert", "freeze")

# hf = hasfields()
# hf.x = 1
# assert_eq(hf.x, 1)
# hf.x = [1, 2]
# hf.x += [3, 4]
# assert_eq(hf.x, [1, 2, 3, 4])
# freeze(hf)
# def setX(hf):
  # hf.x = 2
# def setY(hf):
  # hf.y = 3
# assert.fails(lambda: setX(hf), "cannot set field on a frozen hasfields")
# assert.fails(lambda: setY(hf), "cannot set field on a frozen hasfields")

---
# destucturing assignment in a for loop.


def f():
  res = []
  for (x, y), z in [(["a", "b"], 3), (["c", "d"], 4)]:
    res.append((x, y, z))
  return res
assert_eq(f(), [("a", "b", 3), ("c", "d", 4)])

def g():
  a = {}
  for i, a[i] in [("one", 1), ("two", 2)]:
    pass
  return a
assert_eq(g(), {"one": 1, "two": 2})

---
# parenthesized LHS in augmented assignment (success)

# a = 5
# (a) += 3 ## cannot reassign global a

---
# parenthesized LHS in augmented assignment (error)

# (a) += 5 ## global variable a referenced before assignment

---
_ = abc ### (local variable abc referenced before assignment|undefined|not defined|not found)
---
def f(): assert_eq(1, 1) # forward ref OK

f()

---
def f(): assert_eq(1, 1) # forward ref OK

f()
