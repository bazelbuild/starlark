# insert

foo = ['a', 'b']

foo.insert(0, 'c')
assert_eq(foo, ['c', 'a', 'b'])

foo.insert(1, 'd')
assert_eq(foo, ['c', 'd', 'a', 'b'])

foo.insert(4, 'e')
assert_eq(foo, ['c', 'd', 'a', 'b', 'e'])

foo.insert(-10, 'f')
assert_eq(foo, ['f', 'c', 'd', 'a', 'b', 'e'])

foo.insert(10, 'g')
assert_eq(foo, ['f', 'c', 'd', 'a', 'b', 'e', 'g'])

---
### java: has no field or method
### rust: has no attribute
### go: field or method
(1, 2).insert(3)
---

# append

foo = ['a', 'b']
foo.append('c')
assert_eq(foo, ['a', 'b', 'c'])
foo.append('d')
assert_eq(foo, ['a', 'b', 'c', 'd'])

---
### rust: has no attribute
### go: field or method
### java: has no field or method
(1, 2).append(3)
---

# extend

foo = ['a', 'b']
foo.extend(['c', 'd'])
foo.extend(('e', 'f'))
assert_eq(foo, ['a', 'b', 'c', 'd', 'e', 'f'])

---
### rust: has no attribute
### java: has no field or method
### go: field or method
(1, 2).extend([3, 4])
---
[1, 2].extend(3) ### (expected value of type|got int, want iterable|not iterable|operation.*not supported on type)

# remove

foo = ['a', 'b', 'c', 'b']

foo.remove('b')
assert_eq(foo, ['a', 'c', 'b'])

foo.remove('c')
assert_eq(foo, ['a', 'b'])

foo.remove('a')
assert_eq(foo, ['b'])

foo.remove('b')
assert_eq(foo, [])

---
### rust: has no attribute
### java: has no field or method
### go: field or method
(1, 2).remove(3)
---
[1, 2].remove(3) ### not found
---

# pop

li1 = [2, 3, 4]
assert_eq(li1.pop(), 4)
assert_eq(li1, [2, 3])

li2 = [2, 4]
#li2 = [2, 3, 4]
# _inconsistency_: rust pop() method doesn't support -ve indices
# assert_eq(li2.pop(-2), 3)

assert_eq(li2, [2, 4])

li3 = [2, 3, 4]
assert_eq(li3.pop(1), 3)
assert_eq(li3, [2, 4])

---
[1, 2].pop(3) ### (out of range|out of bound)
---
### rust: has no attribute
### java: has no field or method
### go: field or method
(1, 2).pop()
