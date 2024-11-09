# indexing
assert_eq('somestring'[0], "s")
assert_eq('somestring'[1], "o")
assert_eq('somestring'[4], "s")
assert_eq('somestring'[9], "g")
assert_eq('somestring'[-1], "g")
assert_eq('somestring'[-2], "n")
assert_eq('somestring'[-10], "s")

---
'abcdef'[10] ### (out of range|out of bound)
---
'abcdef'[-11] ### (out of range|out of bound)
---

# slicing
assert_eq('0123'[0:-1], "012")
assert_eq('012345'[2:4], "23")
assert_eq('012345'[-2:-1], "4")
assert_eq(''[1:2], "")
assert_eq('012'[1:0], "")
assert_eq('0123'[-10:10], "0123")

assert_eq('01234'[::1], "01234")
assert_eq('01234'[1::1], "1234")
assert_eq('01234'[:2:1], "01")
assert_eq('01234'[1:3:1], "12")
assert_eq('01234'[-4:-2:1], "12")
assert_eq('01234'[-10:10:1], "01234")
assert_eq('01234'[::42], "0")

assert_eq(''[::1], "")
assert_eq(''[::-1], "")

assert_eq('0123456'[::3], "036")
assert_eq('01234567'[1:7:3], "14")

assert_eq('01234'[::-1], "43210")
assert_eq('01234'[4::-1], "43210")
assert_eq('01234'[:0:-1], "4321")
assert_eq('01234'[3:1:-1], "32")
assert_eq('01234'[::-2], "420")
assert_eq('01234'[::-10], "4")

assert_eq('123'[3:1:1], "")
assert_eq('123'[1:3:-1], "")

---
'123'[::0] ### (slice step cannot be zero|not a valid slice step|out of bound)
---
'123'[1::0] ### (slice step cannot be zero|not a valid slice step|out of bound)
---
'123'[:3:0] ### (slice step cannot be zero|not a valid slice step|out of bound)
---
'123'[1:3:0] ### (slice step cannot be zero|not a valid slice step|out of bound)
---
### java: want int
### go: invalid start index
### rust: not supported
'123'['a'::]
---
### java: want int
### go: invalid end index
### rust: not supported
'123'[:'b':]
---
