# Tests of Starlark 'list'

# literals
assert_eq([], [])
assert_eq([1], [1])
assert_eq([1], [1])
assert_eq([1, 2], [1, 2])
assert_ne([1, 2, 3], [1, 2, 4])

# truth
assert_([0])
assert_(not [])

# indexing, x[i]
---
abc = list("abc".elems())
abc[-4] ### (out of range|out of bound)
---
abc = ["a", "b", "c"]
assert_eq(abc[-3], "a")
assert_eq(abc[-2], "b")
assert_eq(abc[-1], "c")
assert_eq(abc[0], "a")
assert_eq(abc[1], "b")
assert_eq(abc[2], "c")

abc[3] ### (out of range|out of bound)
---

# x[i] = ...
x3 = [0, 1, 2]
x3[1] = 2
x3[2] += 3
assert_eq(x3, [0, 2, 5])

def f2():
    x3[3] = 4

f2() ### (out of range|out of bound)
---

# list + list
assert_eq([1, 2, 3] + [3, 4, 5], [1, 2, 3, 3, 4, 5])

[1, 2] + (3, 4) ### (unknown.*list \+ tuple|unsupported binary|parameters mismatch)
---
(1, 2) + [3, 4] ### (unknown.*tuple \+ list|unsupported binary|parameters mismatch)
---
abc = ["a", "b", "c"]

# list * int,  int * list
assert_eq(abc * 0, [])
assert_eq(abc * -1, [])
assert_eq(abc * 1, abc)
assert_eq(abc * 3, ["a", "b", "c", "a", "b", "c", "a", "b", "c"])
assert_eq(0 * abc, [])
assert_eq(-1 * abc, [])
assert_eq(1 * abc, abc)
assert_eq(3 * abc, ["a", "b", "c", "a", "b", "c", "a", "b", "c"])

# list comprehensions
assert_eq([2 * x for x in [1, 2, 3]], [2, 4, 6])
assert_eq([2 * x for x in [1, 2, 3] if x > 1], [4, 6])
assert_eq(
    [(x, y) for x in [1, 2] for y in [3, 4]],
    [(1, 3), (1, 4), (2, 3), (2, 4)],
)
assert_eq([(x, y) for x in [1, 2] if x == 2 for y in [3, 4]], [(2, 3), (2, 4)])
assert_eq([2 * x for x in (1, 2, 3)], [2, 4, 6])

# _inconsistency_: rust elems() returns list of ints
# assert_eq([x for x in "abc".elems()], ["a", "b", "c"])
# assert_eq(list("ab".elems()), ["a", "b"])

assert_eq([x for x in {"a": 1, "b": 2}], ["a", "b"])
assert_eq([(y, x) for x, y in {1: 2, 3: 4}.items()], [(2, 1), (4, 3)])

# corner cases of parsing:
assert_eq([x for x in range(12) if x % 2 == 0 if x % 3 == 0], [0, 6])
assert_eq([x for x in [1, 2] if not None], [1, 2])
assert_eq([x for x in [1, 2] if 3], [1, 2])

# list function
assert_eq(list(), [])

# _inconsistency_: list comprehension doesn't define a separate block in java
# A list comprehension defines a separate lexical block,
# whether at top-level...
# a = [1, 2]
# b = [a for a in [3, 4]]
# assert_eq(a, [1, 2])
# assert_eq(b, [3, 4])

# ...or local to a function.
# def listcompblock():
#     c = [1, 2]
#     d = [c for c in [3, 4]]
#     assert_eq(c, [1, 2])
#     assert_eq(d, [3, 4])

# listcompblock()
---

# list.pop
x4 = [1, 2, 3, 4, 5]
x4.pop(-6) ### (out of range|out of bound)
---
x4 = [1, 2, 3, 4, 5]
x4.pop(6) ### (out of range|out of bound)
---
x4 = [1, 2, 3, 4, 5]
assert_eq(x4.pop(), 5)
assert_eq(x4, [1, 2, 3, 4])
assert_eq(x4.pop(1), 2)
assert_eq(x4, [1, 3, 4])
assert_eq(x4.pop(0), 1)
assert_eq(x4, [3, 4])

# _inconsistency_: rust pop() doesn't support -ve indices
# assert_eq(x4.pop(-2), 3)
x4.pop(0)

assert_eq(x4, [4])

# assert_eq(x4.pop(-1), 4)
x4.pop()

assert_eq(x4, [])

---
def list_extend():
    a = [1, 2, 3]
    b = a
    a = a + [4]  # creates a new list
    assert_eq(a, [1, 2, 3, 4])
    assert_eq(b, [1, 2, 3])  # b is unchanged

    a = [1, 2, 3]
    b = a
    a += [4]  # updates a (and thus b) in place
    assert_eq(a, [1, 2, 3, 4])
    # _inconsistency_: rust += doesn't update b
    # assert_eq(b, [1, 2, 3, 4])  # alias observes the change

    a = [1, 2, 3]
    b = a
    a.extend([4])  # updates existing list
    assert_eq(a, [1, 2, 3, 4])
    assert_eq(b, [1, 2, 3, 4])  # alias observes the change

list_extend()
---
# _inconsistency_: rust += do not assume LHS is local

# Unlike list.extend(iterable), list += iterable makes its LHS name local.
# a_list = []

# def f4():
#     a_list += [1]  # binding use => a_list is a local var

# f4() ## local variable a_list referenced before assignment
---

# list += <not iterable>
def f5():
    x = []
    x += 1

f5() ### ((unknown|unsupported) binary op|parameters mismatch)
---

# append
x5 = [1, 2, 3]
x5.append(4)
x5.append("abc")
assert_eq(x5, [1, 2, 3, 4, "abc"])

# extend
x5a = [1, 2, 3]
x5a.extend(["a", "b", "c"])
x5a.extend((True, False))  # tuple
assert_eq(x5a, [1, 2, 3, "a", "b", "c", True, False])

# list.insert
def insert_at(index):
    x = list(range(3))
    x.insert(index, 42)
    return x

assert_eq(insert_at(-99), [42, 0, 1, 2])
assert_eq(insert_at(-2), [0, 42, 1, 2])
assert_eq(insert_at(-1), [0, 1, 42, 2])
assert_eq(insert_at(0), [42, 0, 1, 2])
assert_eq(insert_at(1), [0, 42, 1, 2])
assert_eq(insert_at(2), [0, 1, 42, 2])
assert_eq(insert_at(3), [0, 1, 2, 42])
assert_eq(insert_at(4), [0, 1, 2, 42])

# list.remove
def remove(v):
    x = [3, 1, 4, 1]
    x.remove(v)
    return x

assert_eq(remove(3), [1, 4, 1])
assert_eq(remove(1), [3, 4, 1])
assert_eq(remove(4), [3, 1, 1])

[3, 1, 4, 1].remove(42) ### not found
---

# list.index
bananas = ["b", "a", "n", "a", "n", "a", "s"]
assert_eq(bananas.index("a"), 1)  # bAnanas
bananas.index("d") ### (value not in list|not found)
---

bananas = ["b", "a", "n", "a", "n", "a", "s"]
# start
assert_eq(bananas.index("a", -1000), 1)  # bAnanas
assert_eq(bananas.index("a", 0), 1)  # bAnanas
assert_eq(bananas.index("a", 1), 1)  # bAnanas
assert_eq(bananas.index("a", 2), 3)  # banAnas
assert_eq(bananas.index("a", 3), 3)  # banAnas
assert_eq(bananas.index("b", 0), 0)  # Bananas
assert_eq(bananas.index("n", -3), 4)  # banaNas
assert_eq(bananas.index("s", -2), 6)  # bananaS

bananas.index("n", -2) ### (value not in list|not found)
---
bananas = ["b", "a", "n", "a", "n", "a", "s"]
bananas.index("b", 1) ### (value not in list|not found)
---
bananas = ["b", "a", "n", "a", "n", "a", "s"]

# start, end
assert_eq(bananas.index("s", -1000, 7), 6)  # bananaS
bananas.index("s", -1000, 6) ### (value not in list|not found)
---
bananas = ["b", "a", "n", "a", "n", "a", "s"]
bananas.index("d", -1000, 1000) ### (value not in list|not found)
---

bananas = ["b", "a", "n", "a", "n", "a", "s"]

# slicing, x[i:j:k]
assert_eq(bananas[6::-2], ["s", "n", "n", "b"])
assert_eq(bananas[5::-2], ["a", "a", "a"])
assert_eq(bananas[4::-2], ["n", "n", "b"])
assert_eq(bananas[99::-2], ["s", "n", "n", "b"])
assert_eq(bananas[100::-2], ["s", "n", "n", "b"])

---
# iterator invalidation
def iterator1():
    list = [0, 1, 2]
    for x in list:
        list[x] = 2 * x
    return list

iterator1() ### (assign to element.* during iteration|temporarily immutable|Cannot mutate)
---

def iterator2():
    list = [0, 1, 2]
    for x in list:
        list.remove(x)

iterator2() ### (remove.*during iteration|temporarily immutable|Cannot mutate)
---

def iterator3():
    list = [0, 1, 2]
    for x in list:
        list.append(3)

iterator3() ### (append.*during iteration|temporarily immutable|Cannot mutate)
---

def iterator4():
    list = [0, 1, 2]
    for x in list:
        list.extend([3, 4])

iterator4() ### (extend.*during iteration|temporarily immutable|Cannot mutate)
---

def f(x):
    x.append(4)

def iterator5():
    list = [1, 2, 3]
    _ = [f(list) for x in list]

iterator5() ### (append.*during iteration|temporarily immutable|Cannot mutate)
