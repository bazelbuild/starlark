# lists

assert_eq(reversed([]), [])

# _inconsistency_: rust returns list of ints
# assert_eq(reversed('a'.elems()), ['a'])
# assert_eq(reversed('abc'.elems()), ['c', 'b', 'a'])
# assert_eq(reversed('__test  '.elems()), [' ', ' ', 't', 's', 'e', 't', '_', '_'])
# assert_eq(reversed('bbb'.elems()), ['b', 'b', 'b'])

---
reversed(None) ### (got.*want|got NoneType, want iterable|not iterable|operation.*not supported on type)
---
reversed(1) ### (got.*want|not iterable|operation.*not supported on type)
---
# _inconsistency_: go, rust reversed() accepts dict as argument
# reversed({1: 3}) ## Argument to reversed() must be a sequence, not a dictionary
---

x = ['a', 'b']
y = reversed(x)
y.append('c')
assert_eq(y, ['b', 'a', 'c'])
assert_eq(x, ['a', 'b'])

def reverse_equivalence(inp):
  assert_eq(reversed(inp), inp[::-1])
  assert_eq(reversed(reversed(inp)), inp)

reverse_equivalence([])
reverse_equivalence([1])
reverse_equivalence(["a", "b"])
