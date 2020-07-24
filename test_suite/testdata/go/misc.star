# Miscellaneous tests of Starlark evaluation.

# Ordered comparisons require values of the same type.
None < False ### (not impl|cannot compare)
---
False < list ### (not impl|cannot compare)
---
list < {} ### (not impl|cannot compare)
---
{} < None ### (not impl|cannot compare)
---
None < 0 ### (not impl|cannot compare)
---
0 < [] ### (not impl|cannot compare)
---
[] < "" ### (not impl|cannot compare)
---
"" < () ### (not impl|cannot compare)
---

# _inconsistency_: cyclic data structures not supported in Rust and Java
# cyclic data structures
# cyclic = [1, 2, 3] # list cycle
# cyclic[1] = cyclic
# assert_eq(str(cyclic), "[1, [...], 3]")
# assert.fails(lambda: cyclic < cyclic, "maximum recursion")
# assert.fails(lambda: cyclic == cyclic, "maximum recursion")
# cyclic2 = [1, 2, 3]
# cyclic2[1] = cyclic2
# assert.fails(lambda: cyclic2 == cyclic, "maximum recursion")

# cyclic3 = [1, [2, 3]] # list-list cycle
# cyclic3[1][0] = cyclic3
# assert_eq(str(cyclic3), "[1, [[...], 3]]")
# cyclic4 = {"x": 1}
# cyclic4["x"] = cyclic4
# assert_eq(str(cyclic4), "{\"x\": {...}}")
# cyclic5 = [0, {"x": 1}] # list-dict cycle
# cyclic5[1]["x"] = cyclic5
# assert_eq(str(cyclic5), "[0, {\"x\": [...]}]")
# assert_eq(str(cyclic5), "[0, {\"x\": [...]}]")
# assert.fails(lambda: cyclic5 == cyclic5 ,"maximum recursion")
# cyclic6 = [0, {"x": 1}]
# cyclic6[1]["x"] = cyclic6
# assert.fails(lambda: cyclic5 == cyclic6, "maximum recursion")

---
# regression

# was a parse error:
assert_eq(("ababab"[2:]).replace("b", "c"), "acac")
assert_eq("ababab"[2:].replace("b", "c"), "acac")

# test parsing of line continuation, at toplevel and in expression.
three = 1 + \
  2
assert_eq(1 + \
  2, three)

---
# _inconsistency_: java accepts keyword argument default
# A regression test for error position information.
#_ = {}.get(1, default=2) ## get: unexpected keyword arguments

---

s = "s"
l = [4]
t = (4,)

assert_eq("a" + "b" + "c", "abc")
assert_eq("a" + "b" + s + "c", "absc")
assert_eq(() + (1,) + (2, 3), (1, 2, 3))
assert_eq(() + (1,) + t + (2, 3), (1, 4, 2, 3))
assert_eq([] + [1] + [2, 3], [1, 2, 3])
assert_eq([] + [1] + l + [2, 3], [1, 4, 2, 3])

---
"a" + "b" + 1 + "c" ### ((unknown|unsupported) binary op|parameters mismatch)
---
() + () + 1 + () ### ((unknown|unsupported) binary op|parameters mismatch)
---
[] + [] + 1 + [] ### ((unknown|unsupported) binary op|parameters mismatch)
