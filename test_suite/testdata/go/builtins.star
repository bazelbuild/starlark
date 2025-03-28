# Tests of Starlark built-in functions

# len
assert_eq(len([1, 2, 3]), 3)
assert_eq(len((1, 2, 3)), 3)
assert_eq(len({1: 2}), 1)
---
len(1) ### (int.*has no len|not iterable|not supported)
---

# and, or
assert_eq(123 or "foo", 123)
assert_eq(0 or "foo", "foo")
assert_eq(123 and "foo", "foo")
assert_eq(0 and "foo", 0)
none = None
_1 = none and none[0]      # rhs is not evaluated
_2 = (not none) or none[0] # rhs is not evaluated

# any, all
assert_(all([]))
assert_(all([1, True, "foo"]))
assert_(not all([1, True, ""]))
assert_(not any([]))
assert_(any([0, False, "foo"]))
assert_(not any([0, False, ""]))

# in
assert_(3 in [1, 2, 3])
assert_(4 not in [1, 2, 3])
assert_(3 in (1, 2, 3))
assert_(4 not in (1, 2, 3))
assert_(123 in {123: ""})
assert_(456 not in {123:""})

# _inconsistency_: valid syntax in go. Invalid in python, rust, java (list unhashable)
# assert_([] not in {123: ""})
---
3 in "foo" ### (in.*requires string as left operand|parameters mismatch)
---

# sorted
assert_eq(sorted([42, 123, 3]), [3, 42, 123])
assert_eq(sorted(["wiz", "foo", "bar"]), ["bar", "foo", "wiz"])
assert_eq(sorted([42, 123, 3], reverse=True), [123, 42, 3])
assert_eq(sorted(["wiz", "foo", "bar"], reverse=True), ["wiz", "foo", "bar"])

# sort is stable
pairs = [(4, 0), (3, 1), (4, 2), (2, 3), (3, 4), (1, 5), (2, 6), (3, 7)]
def f(x): return x[0]
assert_eq(sorted(pairs, key=f),
        [(1, 5),
         (2, 3), (2, 6),
         (3, 1), (3, 4), (3, 7),
         (4, 0), (4, 2)])

# custom key function
assert_eq(sorted(["two", "three", "four"], key=len),
        ["two", "four", "three"])
assert_eq(sorted(["two", "three", "four"], key=len, reverse=True),
        ["three", "four", "two"])

---
### java: Error in sorted
### rust: not supported
### go: Error in sorted
sorted(1)
---
### java: unsupported
### rust: not supported
### go: Error in sorted
sorted([1, 2, None, 3])
---
### java: unsupported
### rust: not supported
### go: Error in sorted
sorted([1, "one"])
---
# _inconsistency_: java accepts key to be None
# sorted([1, 2, 3], key=None) ## (want callable|not supported)
---

# reversed
assert_eq(reversed([1, 144, 81, 16]), [16, 81, 144, 1])

# set
#assert.contains(set([1, 2, 3]), 1)
#assert_(4 not in set([1, 2, 3]))
#assert_eq(len(set([1, 2, 3])), 3)
#assert_eq(sorted([x for x in set([1, 2, 3])]), [1, 2, 3])

# dict
assert_eq(dict([(1, 2), (3, 4)]), {1: 2, 3: 4})
assert_eq(dict([(1, 2), (3, 4)], foo="bar"), {1: 2, 3: 4, "foo": "bar"})
assert_eq(dict({1:2, 3:4}), {1: 2, 3: 4})
assert_eq(dict({1:2, 3:4}.items()), {1: 2, 3: 4})

# range
assert_eq(range(0, 5, 10), range(0, 5, 11))

# _inconsistency_: rust range() returns a tuple
# assert_eq("range(0, 10, -1)", str(range(0, 10, -1)))
# assert_eq("range(1, 10)", str(range(1, 10)))
# assert_eq("range(10)", str(range(0, 10, 1)))
# assert_eq("range", type(range(10)))

assert_(bool(range(1, 2)))
assert_(not(range(2, 1))) # an empty range is false
assert_eq([x*x for x in range(5)], [0, 1, 4, 9, 16])
assert_eq(list(range(5)), [0, 1, 2, 3, 4])
assert_eq(list(range(-5)), [])
assert_eq(list(range(2, 5)), [2, 3, 4])
assert_eq(list(range(5, 2)), [])
assert_eq(list(range(-2, -5)), [])
assert_eq(list(range(-5, -2)), [-5, -4, -3])
assert_eq(list(range(2, 10, 3)), [2, 5, 8])
assert_eq(list(range(10, 2, -3)), [10, 7, 4])
assert_eq(list(range(-2, -10, -3)), [-2, -5, -8])
assert_eq(list(range(-10, -2, 3)), [-10, -7, -4])
assert_eq(list(range(10, 2, -1)), [10, 9, 8, 7, 6, 5, 4, 3])
assert_eq(list(range(5)[1:]), [1, 2, 3, 4])
assert_eq(len(range(5)[1:]), 4)
assert_eq(list(range(5)[:2]), [0, 1])
assert_eq(list(range(10)[1:]), [1, 2, 3, 4, 5, 6, 7, 8, 9])
assert_eq(list(range(10)[1:9:2]), [1, 3, 5, 7])
assert_eq(list(range(10)[1:10:2]), [1, 3, 5, 7, 9])
assert_eq(list(range(10)[1:11:2]), [1, 3, 5, 7, 9])
assert_eq(list(range(10)[::-2]), [9, 7, 5, 3, 1])
assert_eq(list(range(0, 10, 2)[::2]), [0, 4, 8])
assert_eq(list(range(0, 10, 2)[::-2]), [8, 4, 0])

# _inconsistency_: rust range runs in O(n), takes too long
#assert_eq(len(range(0x7fffffff)), 0x7fffffff) # O(1)
---
# _inconsistency_: range is hashable in rust, java, python, not hashable in go
# {range(10): 10} ## unhashable: range
---
# _inconsistency_: rust range runs in O(n), takes too long, accepts args > 32-bit ints
# signed 32-bit values only
# range(3000000000) ## 3000000000 out of range
---

# Two ranges compare equal if they denote the same sequence:
assert_eq(range(0), range(2, 1, 3))       # []
assert_eq(range(0, 3, 2), range(0, 4, 2)) # [0, 2]
assert_ne(range(1, 10), range(2, 10))
---
# _inconsistency_: rust allows range comparison since it returns tuple
# range(0) < range(0) ## range < range not implemented
---

# <number> in <range>
assert_eq(1 in range(3), True)
assert_(4 not in range(4))
---
# _inconsistency_: this is valid in java, rust, python
# bools aren't numbers
# True in range(3) ## requires integer.*not bool
---
# _inconsistency_: this is valid in java, rust, python. not valid in go
# "one" in range(10) ## requires integer.*not string
---
# https://github.com/google/starlark-go/issues/116
range(0, 0, 2)[:][0] ### (out of range|out of bound)
---

# list
# _inconsistency_: rust elems() returns list of ints when called on string
# assert_eq(list("abc".elems()), ["a", "b", "c"])

assert_eq(sorted(list({"a": 1, "b": 2})), ['a', 'b'])

# min, max
assert_eq(min(5, -2, 1, 7, 3), -2)
assert_eq(max(5, -2, 1, 7, 3), 7)
assert_eq(min([5, -2, 1, 7, 3]), -2)
assert_eq(min("one", "two", "three", "four"), "four")
assert_eq(max("one", "two", "three", "four"), "two")

# _inconsistency_: java min() doesn't support key arg
#assert_eq(min(5, -2, 1, 7, 3, key=lambda x: x*x), 1) # min absolute value
#assert_eq(min(5, -2, 1, 7, 3, key=lambda x: -x), 7) # min negated value
---
min() ### (at least one (positional argument|item)|empty)
---
min(1) ### (not iterable|operation.*not supported)
---
min([]) ### (empty|expected at least one item)
---

# _inconsistency_: rust elems() returns list of ints when called on string
# enumerate
# assert_eq(enumerate("abc".elems()), [(0, "a"), (1, "b"), (2, "c")])
#assert_eq(zip("abc".elems(),
#              list("def".elems()),
#              "hijk".elems()),
#          [("a", "d", "h"), ("b", "e", "i"), ("c", "f", "j")])

assert_eq(enumerate([False, True, None], 42), [(42, False), (43, True), (44, None)])

# zip
assert_eq(zip(), [])
assert_eq(zip([]), [])
assert_eq(zip([1, 2, 3]), [(1,), (2,), (3,)])
assert_eq(zip("".elems()), [])
z1 = [1]
assert_eq(zip(z1), [(1,)])
z1.append(2)
assert_eq(zip(z1), [(1,), (2,)])
z1.append(3)
---
zip([1, 2, 3], 1) ### (not iterable|operation.*not supported)
---

# dir for builtin_function_or_method
assert_eq(dir(None), [])
assert_eq(dir({})[:3], ["clear", "get", "items"]) # etc
assert_eq(dir(1), [])
assert_eq(dir([])[:3], ["append", "clear", "extend"]) # etc

assert_(hasattr("", "find"))
assert_(not hasattr("", "x"))
assert_eq(getattr("", "x", 42), 42)
---
getattr("", "x") ### (no.* field or method|not supported)
---

# dir returns a new, sorted, mutable list
assert_eq(sorted(dir("")), dir("")) # sorted
dir("").append("!") # mutable
assert_("!" not in dir("")) # new


# repr
assert_eq(repr(1), "1")
assert_eq(repr("x"), '"x"')
assert_eq(repr(["x", 1]), '["x", 1]')

 # fail
---
# _inconsistency_: rust fail cannot be called without args
# fail() ## (fail:|None)
---
fail(1) ### 1
---

# _inconsistency_: java fail() does not support *args nor separator
#fail(1, 2, 3) ## `fail: 1 2 3`
---
#fail(1, 2, 3, sep="/") ## `fail: 1/2/3`
