# Tests of Starlark 'dict'

# literals
assert_eq({}, {})
assert_eq({"a": 1}, {"a": 1})
assert_eq({"a": 1,}, {"a": 1})

# truth
assert_({False: False})
assert_(not {})

---
# _inconsistency_: rust supports dict + dict
# dict + dict is no longer supported.
# {"a": 1} + {"b": 2} ## unknown binary op: dict \+ dict
---

# dict comprehension
assert_eq({x: x*x for x in range(3)}, {0: 0, 1: 1, 2: 4})

# dict.pop
x6 = {"a": 1, "b": 2}
assert_eq(x6.pop("a"), 1)
assert_eq(str(x6), '{"b": 2}')
assert_eq(x6.pop("c", 3), 3)

# _inconsistency_: rust fails when default=None
# assert_eq(x6.pop("c", None), None) # default=None tests an edge case of UnpackArgs

assert_eq(x6.pop("b"), 2)
assert_eq(len(x6), 0)
x6.pop("c") ### (missing key|keyerror|not found)
---

# dict.popitem
x7 = {"a": 1, "b": 2}
assert_eq([x7.popitem(), x7.popitem()], [("a", 1), ("b", 2)])
assert_eq(len(x7), 0)
x7.popitem() ### empty
---

# dict.keys, dict.values
x8 = {"a": 1, "b": 2}
assert_eq(x8.keys(), ["a", "b"])
assert_eq(x8.values(), [1, 2])

# equality
assert_eq({"a": 1, "b": 2}, {"a": 1, "b": 2})
assert_eq({"a": 1, "b": 2,}, {"a": 1, "b": 2})
assert_eq({"a": 1, "b": 2}, {"b": 2, "a": 1})

# insertion order is preserved
assert_eq(dict([("a", 0), ("b", 1), ("c", 2), ("b", 3)]).keys(), ["a", "b", "c"])
assert_eq(dict([("b", 0), ("a", 1), ("b", 2), ("c", 3)]).keys(), ["b", "a", "c"])
assert_eq(dict([("b", 0), ("a", 1), ("b", 2), ("c", 3)])["b"], 2)
# ...even after rehashing (which currently occurs after key 'i'):
small = dict([("a", 0), ("b", 1), ("c", 2)])
small.update([("d", 4), ("e", 5), ("f", 6), ("g", 7), ("h", 8), ("i", 9), ("j", 10), ("k", 11)])
assert_eq(small.keys(), ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k"])

# _inconsistency_: duplicate keys allowed in rust, python. Not allowed in java, go
# Duplicate keys are not permitted in dictionary expressions (see b/35698444).
# (Nor in keyword args to function calls---checked by resolver.)
# {"aa": 1, "bb": 2, "cc": 3, "bb": 4} ## duplicate key: "bb"

# _inconsistency_: valid syntax in rust, takes value of last key
# Check that even with many positional args, keyword collisions are detected.
# dict({'b': 3}, a=4, **dict(a=5)) ## dict: duplicate keyword arg: "a"
# dict({'a': 2, 'b': 3}, a=4, **dict(a=5)) ## dict: duplicate keyword arg: "a"

# positional/keyword arg key collisions are ok
assert_eq(dict((['a', 2], ), a=4), {'a': 4})
assert_eq(dict((['a', 2], ['a', 3]), a=4), {'a': 4})

# index
---
x9 = {}
x9["a"] ### (key "a" not in dict|not found)
---
def setIndex(d, k, v):
  d[k] = v

x9 = {}
x9["a"] = 1
assert_eq(x9["a"], 1)
assert_eq(x9, {"a": 1})
setIndex(x9, [], 2) ### (unhashable|not hashable)
---

x9a = {}
x9a[1, 2] = 3  ### rust: left-hand-side of assignment must take
assert_eq(x9a.keys()[0], (1, 2))

---

# dict.get
x10 = {"a": 1}
assert_eq(x10.get("a"), 1)
assert_eq(x10.get("b"), None)
assert_eq(x10.get("a", 2), 1)
assert_eq(x10.get("b", 2), 2)

# dict.clear
x11 = {"a": 1}
assert_("a" in x11)
assert_eq(x11["a"], 1)
x11.clear()
assert_("a" not in x11)
x11["a"] ### (key "a" not in dict|not found)
---

# dict.setdefault
x12 = {"a": 1}
assert_eq(x12.setdefault("a"), 1)
assert_eq(x12["a"], 1)
assert_eq(x12.setdefault("b"), None)
assert_eq(x12["b"], None)
assert_eq(x12.setdefault("c", 2), 2)
assert_eq(x12["c"], 2)
assert_eq(x12.setdefault("c", 3), 2)
assert_eq(x12["c"], 2)
assert_eq(x12.setdefault("a", 1), 1) # no change, no error

# dict.update
x13 = {"a": 1}
x13.update(a=2, b=3)
assert_eq(x13, {"a": 2, "b": 3})
x13.update([("b", 4), ("c", 5)])
assert_eq(x13, {"a": 2, "b": 4, "c": 5})
x13.update({"c": 6, "d": 7})
assert_eq(x13, {"a": 2, "b": 4, "c": 6, "d": 7})

# dict as a sequence
#
# for loop
x14 = {1:2, 3:4}
def keys(dict):
  keys = []
  for k in dict: keys.append(k)
  return keys
assert_eq(keys(x14), [1, 3])
#
# comprehension
assert_eq([x for x in x14], [1, 3])

x15 = {"one": 1}

# _inconsistency_: rust returns list of keys
# varargs
# def varargs(*args): return args
# assert_eq(varargs(*x15), ("one",))

# kwargs parameter does not alias the **kwargs dict
def kwargs(**kwargs): return kwargs
x16 = kwargs(**x15)
assert_eq(x16, x15)
x15["two"] = 2 # mutate
assert_ne(x16, x15)
---

# iterator invalidation
def iterator1():
  dict = {1:1, 2:1}
  for k in dict:
    dict[2*k] = dict[k]
iterator1() ### (insert.*during iteration|cannot mutate|temporarily immutable|mutate an iterable)
---

def iterator2():
  dict = {1:1, 2:1}
  for k in dict:
    dict.pop(k)
iterator2() ### (delete.*during iteration|cannot mutate|temporarily immutable|mutate an iterable)
---

def f(d):
  d[3] = 3
def iterator3():
  dict = {1:1, 2:1}
  _ = [f(dict) for x in dict]
iterator3() ### (insert.*during iteration|cannot mutate|temporarily immutable|mutate an iterable)
---

# This assignment is not a modification-during-iteration:
# the sequence x should be completely iterated before
# the assignment occurs.
def f():
  x = {1:2, 2:4}
  a, x[0] = x
  assert_eq(a, 1)
  assert_eq(x, {1: 2, 2: 4, 0: 2})
# _inconsistency_: rust thinks there is a modification-during-iteration here
#f()

# Regression test for a bug in hashtable.delete
def test_delete():
  d = {}

  # delete tail first
  d["one"] = 1
  d["two"] = 2
  assert_eq(str(d), '{"one": 1, "two": 2}')
  d.pop("two")
  assert_eq(str(d), '{"one": 1}')
  d.pop("one")
  assert_eq(str(d), '{}')

  # delete head first
  d["one"] = 1
  d["two"] = 2
  assert_eq(str(d), '{"one": 1, "two": 2}')
  d.pop("one")
  assert_eq(str(d), '{"two": 2}')
  d.pop("two")
  assert_eq(str(d), '{}')

  # delete middle
  d["one"] = 1
  d["two"] = 2
  d["three"] = 3
  assert_eq(str(d), '{"one": 1, "two": 2, "three": 3}')
  d.pop("two")
  assert_eq(str(d), '{"one": 1, "three": 3}')
  d.pop("three")
  assert_eq(str(d), '{"one": 1}')
  d.pop("one")
  assert_eq(str(d), '{}')

test_delete()

---
# Regression test for github.com/google/starlark-go/issues/128.
dict(None) ### (got NoneType, want iterable|cannot be none|not iterable|operation.*not supported)
---
{}.update(None) ### (got NoneType, want iterable|cannot be none|expected list or dict|operation.*not supported)
---
# Verify position of an "unhashable key" error in a dict literal.

_ = {
    "one": 1,
    ["two"]: 2, ### (unhashable type|not hashable)
    "three": 3,
}

---
# _inconsistency_: duplicate key valid in rust, python
# Verify position of a "duplicate key" error in a dict literal.

#_ = {
#    "one": 1,
#    "one": 1, ## duplicate key: "one"
#    "three": 3,
#}

---
# Verify position of an "unhashable key" error in a dict comprehension.

_ = {
    k: v ### (unhashable type|not hashable)
    for k, v in [
        ("one", 1),
        (["two"], 2),
        ("three", 3),
    ]
}
