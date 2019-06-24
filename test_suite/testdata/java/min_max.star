# min / max

# _inconsistency_: rust elems() returns list of ints
# assert_eq(min("abcdefxyz".elems()), "a")

assert_eq(min("test", "xyz"), "test")

assert_eq(min([4, 5], [1]), [1])
assert_eq(min([1, 2], [3]), [1, 2])
assert_eq(min([1, 5], [1, 6], [2, 4], [0, 6]), [0, 6])
assert_eq(min([-1]), -1)
assert_eq(min([5, 2, 3]), 2)
assert_eq(min({1: 2, -1 : 3}), -1)
assert_eq(min({2: None}), 2)
assert_eq(min(-1, 2), -1)
assert_eq(min(5, 2, 3), 2)
assert_eq(min(1, 1, 1, 1, 1, 1), 1)
assert_eq(min([1, 1, 1, 1, 1, 1]), 1)

# _inconsistency_: rust elems() returns list of ints
# assert_eq(max("abcdefxyz".elems()), "z")

assert_eq(max("test", "xyz"), "xyz")
assert_eq(max("test", "xyz"), "xyz")
assert_eq(max([1, 2], [5]), [5])
assert_eq(max([-1]), -1)
assert_eq(max([5, 2, 3]), 5)
assert_eq(max({1: 2, -1 : 3}), 1)
assert_eq(max({2: None}), 2)
assert_eq(max(-1, 2), 2)
assert_eq(max(5, 2, 3), 5)
assert_eq(max(1, 1, 1, 1, 1, 1), 1)
assert_eq(max([1, 1, 1, 1, 1, 1]), 1)

---
min(1)  ### not iterable
---
min([])  ### (expected at least one item|empty)
---
max([]) ### (expected at least one item|empty)
---
max(1) ### not iterable
---

# _inconsistency_: rust supports comparision between ints and strings
# min(1, "2", True) ## (Cannot compare int with string|not implemented)
---
# min([1, "2", True]) ## (Cannot compare int with string|not implemented)
---
# max(1, '2', True) ## (Cannot compare int with string|not implemented)
---
# max([1, '2', True]) ## (Cannot compare int with string|not implemented)
---
