# Without step
assert_eq([0, 1, 2, 3][0:-1], [0, 1, 2])
assert_eq([0, 1, 2, 3, 4, 5][2:4], [2, 3])
assert_eq([0, 1, 2, 3, 4, 5][-2:-1], [4])
assert_eq([][1:2], [])
assert_eq([0, 1, 2, 3][-10:10], [0, 1, 2, 3])

# With step
assert_eq([1, 2, 3, 4, 5][::1], [1, 2, 3, 4, 5])
assert_eq([1, 2, 3, 4, 5][1::1], [2, 3, 4, 5])
assert_eq([1, 2, 3, 4, 5][:2:1], [1, 2])
assert_eq([1, 2, 3, 4, 5][1:3:1], [2, 3])
assert_eq([1, 2, 3, 4, 5][-4:-2:1], [2, 3])
assert_eq([1, 2, 3, 4, 5][-10:10:1], [1, 2, 3, 4, 5])
assert_eq([1, 2, 3, 4, 5][::42], [1])
assert_eq([][::1], [])
assert_eq([][::-1], [])
assert_eq([1, 2, 3, 4, 5, 6, 7][::3], [1, 4, 7])
assert_eq([1, 2, 3, 4, 5, 6, 7, 8, 9][1:7:3], [2, 5])
assert_eq([1, 2, 3][3:1:1], [])
assert_eq([1, 2, 3][1:3:-1], [])

# Negative step
assert_eq([1, 2, 3, 4, 5][::-1], [5, 4, 3, 2, 1])
assert_eq([1, 2, 3, 4, 5][4::-1], [5, 4, 3, 2, 1])
assert_eq([1, 2, 3, 4, 5][:0:-1], [5, 4, 3, 2])
assert_eq([1, 2, 3, 4, 5][3:1:-1], [4, 3])
assert_eq([1, 2, 3, 4, 5][::-2], [5, 3, 1])
assert_eq([1, 2, 3, 4, 5][::-10], [5])

# None
assert_eq([1, 2, 3][None:None:None], [1, 2, 3])
assert_eq([1, 2, 3][None:None], [1, 2, 3])
assert_eq([1, 2, 3][None:2:None], [1, 2])

# Tuples
assert_eq(()[1:2], ())
assert_eq(()[::1], ())
assert_eq((0, 1, 2, 3)[0:-1], (0, 1, 2))
assert_eq((0, 1, 2, 3, 4, 5)[2:4], (2, 3))
assert_eq((0, 1, 2, 3)[-10:10], (0, 1, 2, 3))
assert_eq((1, 2, 3, 4, 5)[-10:10:1], (1, 2, 3, 4, 5))
assert_eq((1, 2, 3, 4, 5, 6, 7, 8, 9)[1:7:3], (2, 5))
assert_eq((1, 2, 3, 4, 5)[::-1], (5, 4, 3, 2, 1))
assert_eq((1, 2, 3, 4, 5)[3:1:-1], (4, 3))
assert_eq((1, 2, 3, 4, 5)[::-2], (5, 3, 1))
assert_eq((1, 2, 3, 4, 5)[::-10], (5,))

# index
assert_eq(['a', 'b', 'c', 'd'][0], 'a')
assert_eq(['a', 'b', 'c', 'd'][1], 'b')
assert_eq(['a', 'b', 'c', 'd'][-1], 'd')
assert_eq(['a', 'b', 'c', 'd'][-2], 'c')
assert_eq([0, 1, 2][-3], 0)
assert_eq([0, 1, 2][-2], 1)
assert_eq([0, 1, 2][-1], 2)
assert_eq([0, 1, 2][0], 0)

---
'123'['a'::] ### (got.*want|invalid start index|parameters mismatch)
---
'123'[:'b':] ### (got.*want|invalid end index|parameters mismatch)
---
(1, 2, 3)[1::0] ### (slice step cannot be zero|zero is not a valid slice step|out of bound)
---
[1, 2, 3][::0] ### (slice step cannot be zero|zero is not a valid slice step|out of bound)
---
[1, 2, 3][1::0] ### (slice step cannot be zero|zero is not a valid slice step|out of bound)
---
[1, 2, 3][:3:0] ### (slice step cannot be zero|zero is not a valid slice step|out of bound)
---
[1, 2, 3][1:3:0] ### (slice step cannot be zero|zero is not a valid slice step|out of bound)
---
[[1], [2]]['a'] ### (got.*want|parameters mismatch)
---
[0, 1, 2][3] ### (out of range|out of bound)
---
[0, 1, 2][-4] ### (out of range|out of bound)
---
[0][-2] ### (out of range|out of bound)
---
[0][1] ### (out of range|out of bound)
---
[][1] ### (out of range|out of bound)
