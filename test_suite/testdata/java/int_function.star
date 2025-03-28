# int
assert_eq(int(0), 0)
assert_eq(int(42), 42)
assert_eq(int(-1), -1)
assert_eq(int(2147483647), 2147483647)
# _inconsistency_: rust doesn't allow -2147483648 as an int value
# -2147483648 is not actually a valid int literal even though it's a
# valid int value, hence the -1 expression.
# assert_eq(int(-2147483647 - 1), -2147483647 - 1)
assert_eq(int(True), 1)
assert_eq(int(False), 0)

---
int(None) ### None
---
# _inconsistency_: rust allows int() without an argument
# This case is allowed in Python but not Skylark
# int() ## (required positional argument|not enough parameters|missing argument)
---

# string, no base
# Includes same numbers as integer test cases above.
assert_eq(int('0'), 0)
assert_eq(int('42'), 42)
assert_eq(int('-1'), -1)
assert_eq(int('2147483647'), 2147483647)
# _inconsistency_: rust doesn't allow -2147483648 as an int value
# assert_eq(int('-2147483648'), -2147483647 - 1)
# Leading zero allowed when not using base = 0.
assert_eq(int('016'), 16)
# Leading plus sign allowed for strings.
assert_eq(int('+42'), 42)

---
# _inconsistency_: go, rust allow 64-bit ints
# int(2147483648) ## invalid base-10 integer constant: 2147483648
---
# int(-2147483649) ## invalid base-10 integer constant: 2147483649
---
### rust: Cannot parse
### java: Error in int
### go: invalid literal
int('')
---
### rust: Cannot parse
### java: Error in int
### go: invalid literal
int('  42  ')
---
### rust: Cannot parse
### java: Error in int
### go: invalid literal
int('-')
---
### rust: Cannot parse
### java: Error in int
### go: invalid literal
int('0x')
---
### rust: Cannot parse
### java: Error in int
### go: invalid literal
int('1.5')
---
### rust: Cannot parse
### java: Error in int
### go: invalid literal
int('ab')
---

assert_eq(int('11', 2), 3)
assert_eq(int('-11', 2), -3)
assert_eq(int('11', 9), 10)
assert_eq(int('AF', 16), 175)
assert_eq(int('11', 36), 37)
assert_eq(int('az', 36), 395)
assert_eq(int('11', 10), 11)
assert_eq(int('11', 0), 11)
assert_eq(int('016', 8), 14)
assert_eq(int('016', 16), 22)

---
# _inconsistency_: rust doesn't complain about this
# invalid base
# int('016', 0) ## base.*016
---
### rust: Cannot parse
### java: Error in int
### go: invalid literal
int('123', 3)
---
### rust: Cannot parse
### java: Error in int
### go: invalid literal
int('FF', 15)
---
### rust: not a valid base
### java: Error in int
### go: base must be
int('123', -1)
---
### rust: not a valid base
### java: Error in int
### go: base must be
int('123', 1)
---
### rust: not a valid base
### java: Error in int
### go: base must be
int('123', 37)
---
### rust: Type of parameter
### java: Error in int
### go: want int
int('123', 'x')
---

# base with prefix
assert_eq(int('0b11', 0), 3)
assert_eq(int('-0b11', 0), -3)
assert_eq(int('+0b11', 0), 3)
assert_eq(int('0B11', 2), 3)
assert_eq(int('0o11', 0), 9)
assert_eq(int('0O11', 8), 9)
assert_eq(int('0XFF', 0), 255)
assert_eq(int('0xFF', 16), 255)

---
### rust: Cannot parse
### java: Error in int
### go: invalid literal
int('0xFF', 8)
---
### rust: non-string
### java: Error in int
### go: non-string with explicit base
int(True, 2)
---
### rust: non-string
### java: Error in int
### go: non-string with explicit base
int(1, 2)
---
### rust: non-string
### java: Error in int
### go: non-string with explicit base
int(True, 10)
