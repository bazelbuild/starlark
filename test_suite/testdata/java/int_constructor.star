assert_eq(int('1'), 1)
assert_eq(int('-1234'), -1234)
assert_eq(int(42), 42)
assert_eq(int(-1), -1)
assert_eq(int(True), 1)
assert_eq(int(False), 0)
assert_eq(int('11', 2), 3)
assert_eq(int('11', 9), 10)
assert_eq(int('AF', 16), 175)
assert_eq(int('11', 36), 37)
assert_eq(int('az', 36), 395)
assert_eq(int('11', 10), 11)
assert_eq(int('11', 0), 11)
assert_eq(int('0b11', 0), 3)
assert_eq(int('0B11', 2), 3)
assert_eq(int('0o11', 0), 9)
assert_eq(int('0O11', 8), 9)
assert_eq(int('0XFF', 0), 255)
assert_eq(int('0xFF', 16), 255)

---
int('1.5') ### base
---
int('ab') ### base
---
int(None) ### None
---
int('123', 3) ### base
---
int('FF', 15) ### base
---
int('123', -1) ### base
---
int('123', 1) ### base
---
int('123', 37) ### base
---
int('0xFF', 8) ### base
---
int(True, 2) ### (can't convert non-string with explicit base|non-string)
---
int(1, 2) ### (can't convert non-string with explicit base|non-string)
---
int(True, 10) ### (can't convert non-string with explicit base|non-string)
