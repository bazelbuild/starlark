# Tests of Starlark 'tuple'

# literal
assert_eq((), ())
assert_eq((1), 1)
assert_eq((1,), (1,))
assert_ne((1), (1,))
assert_eq((1, 2), (1, 2))
assert_eq((1, 2, 3, 4, 5), (1, 2, 3, 4, 5))
assert_ne((1, 2, 3), (1, 2, 4))

# truth
assert_((False,))
assert_((False, False))
assert_(not ())

# indexing, x[i]
assert_eq(("a", "b")[0], "a")
assert_eq(("a", "b")[1], "b")

# slicing, x[i:j]
assert_eq("abcd"[0:4:1], "abcd")
assert_eq("abcd"[::2], "ac")
assert_eq("abcd"[1::2], "bd")
assert_eq("abcd"[4:0:-1], "dcb")
# _inconsistency_: rust elems return ord of chars
# banana = tuple("banana".elems())
# assert_eq(banana[7::-2], tuple("aaa".elems()))
# assert_eq(banana[6::-2], tuple("aaa".elems()))
# assert_eq(banana[5::-2], tuple("aaa".elems()))
# assert_eq(banana[4::-2], tuple("nnb".elems()))

# tuple
assert_eq(tuple(), ())
assert_eq(tuple(["a", "b", "c"]), ("a", "b", "c"))
assert_eq(tuple(["a", "b", "c"]), ("a", "b", "c"))
assert_eq(tuple([1]), (1,))
---
tuple(1) ### (got int, want iterable|not iterable|not a collection)
---

# tuple * int,  int * tuple
abc = tuple(["a", "b", "c"])
assert_eq(abc * 0, ())
assert_eq(abc * -1, ())
assert_eq(abc * 1, abc)
assert_eq(abc * 3, ("a", "b", "c", "a", "b", "c", "a", "b", "c"))
assert_eq(0 * abc, ())
assert_eq(-1 * abc, ())
assert_eq(1 * abc, abc)
assert_eq(3 * abc, ("a", "b", "c", "a", "b", "c", "a", "b", "c"))
# _inconsistency_: java supports up to 32 bit ints
# assert.fails(lambda : abc * (1000000 * 1000000), "repeat count 1000000000000 too large")
# assert.fails(lambda : abc * 1000000 * 1000000, "excessive repeat .3000000000000 elements")
