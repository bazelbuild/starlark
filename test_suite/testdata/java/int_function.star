# int
assert_eq(int(0), 0)
assert_eq(int(42), 42)
assert_eq(int(-1), -1)
assert_eq(int(2147483647), 2147483647)
# -2147483648 is not actually a valid int literal even though it's a
# valid int value, hence the -1 expression.
assert_eq(int(-2147483647 - 1), -2147483647 - 1)
assert_eq(int(True), 1)
assert_eq(int(False), 0)

---
int(None) ### None
---
# This case is allowed in Python but not Skylark
int() ### (required positional argument|not enough parameters|missing argument)
---

# string, no base
# Includes same numbers as integer test cases above.
assert_eq(int('0'), 0)
assert_eq(int('42'), 42)
assert_eq(int('-1'), -1)
assert_eq(int('2147483647'), 2147483647)
assert_eq(int('-2147483648'), -2147483647 - 1)
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
int('') ### (cannot be empty|invalid literal|not a base 10)
---
# Surrounding whitespace is not allowed
int('  42  ') ### (invalid literal|not a base 10)
---
int('-') ### (invalid literal|not a base 10)
---
int('0x') ### (invalid literal|not a base 16)
---
int('1.5') ### (invalid literal|not a base 10)
---
int('ab') ### (invalid literal|not a base 10)
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
int('123', 3) ### (invalid literal|not a base 3)
---
int('FF', 15) ### (invalid literal|not a base 15)
---
int('123', -1) ### >= 2 (and|&&) <= 36
---
int('123', 1) ### >= 2 (and|&&) <= 36
---
int('123', 37) ### >= 2 (and|&&) <= 36
---
int('123', 'x') ### (base must be an integer|not supported)
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
int('0xFF', 8) ### (invalid literal|not a base 8)
---
int(True, 2) ### (can't convert non-string with explicit base|non-string)
---
int(1, 2) ### (can't convert non-string with explicit base|non-string)
---
int(True, 10) ### (can't convert non-string with explicit base|non-string)
