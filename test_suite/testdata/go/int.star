# Tests of Starlark 'int'


# basic arithmetic
assert_eq(0 - 1, -1)
assert_eq(0 + 1, 1)
assert_eq(1 + 1, 2)
assert_eq(5 + 7, 12)
assert_eq(5 * 7, 35)
assert_eq(5 - 7, -2)

# int boundaries
# _inconsistency_: Java implementation currently supports only signed 32-bit integers
# maxint64 = 9223372036854775807
# minint64 = -9223372036854775808
maxint32 = 2147483647
minint32 = -2147483647 - 1


# truth
def truth():
  assert_(not 0)
  for m in [1, maxint32]: # Test small/big ranges
    assert_(-1*m)

truth()

# floored division
def division():
  for m in [1, maxint32 // 100]: # Test small/big ranges
    assert_eq((100*m) // (7*m), 14)
    assert_eq((100*m) // (-7*m), -15)
    assert_eq((-100*m) // (7*m), -15) # NB: different from Go/Java
    assert_eq((-100*m) // (-7*m), 14) # NB: different from Go/Java
    assert_eq((98*m) // (7*m), 14)
    assert_eq((98*m) // (-7*m), -14)
    assert_eq((-98*m) // (7*m), -14)
    assert_eq((-98*m) // (-7*m), 14)

division()

# remainder
def remainder():
  for m in [1, maxint32 // 100]: # Test small/big ranges
    assert_eq((100*m) % (7*m), 2*m)
    assert_eq((100*m) % (-7*m), -5*m) # NB: different from Go/Java
    assert_eq((-100*m) % (7*m), 5*m) # NB: different from Go/Java
    assert_eq((-100*m) % (-7*m), -2*m)
    assert_eq((98*m) % (7*m), 0)
    assert_eq((98*m) % (-7*m), 0)
    assert_eq((-98*m) % (7*m), 0)
    assert_eq((-98*m) % (-7*m), 0)

remainder()

# compound assignment
def compound():
  x = 1
  x += 1
  assert_eq(x, 2)
  x -= 3
  assert_eq(x, -1)
  x *= 39
  assert_eq(x, -39)
  x //= 4
  assert_eq(x, -10)
  x //= -2
  assert_eq(x, 5)
  x %= 3
  assert_eq(x, 2)
  # _inconsistency: java does not support bitwise operations yet
  # x = 2
  # x &= 1
  # assert_eq(x, 0)
  # x |= 2
  # assert_eq(x, 2)
  # x ^= 3
  # assert_eq(x, 1)
  # x <<= 2
  # assert_eq(x, 4)
  # x >>=2
  # assert_eq(x, 1)

compound()


# int conversion
# We follow Python 3 here, but I can't see the method in its madness.
# int from bool/int/float
---
int() ### (missing argument|no default value|not enough parameters)
---
assert_eq(int(False), 0)
assert_eq(int(True), 1)
assert_eq(int(3), 3)
---
int(3, base=10) ### non-string with explicit base
---
int(True, 10) ### non-string with explicit base
---
# int from string, base implicitly 10
assert_eq(int("100000000"), 10000 * 10000)
assert_eq(int("-100000000"), -10000 * 10000)
assert_eq(int("123"), 123)
assert_eq(int("-123"), -123)
assert_eq(int("0123"), 123) # not octal
assert_eq(int("-0123"), -123)
---
# _inconsistency_: rust accepts these conversions
# int("0x12") ## invalid literal.*base 10
---
# int("-0x12") ## invalid literal.*base 10
---
# int("0o123") ## invalid literal.*base 10
---
# int("-0o123") ## invalid literal.*base 10
---

# int from string, explicit base
assert_eq(int("0"), 0)
assert_eq(int("00"), 0)
assert_eq(int("0", base=10), 0)
assert_eq(int("00", base=10), 0)

# _inconsistency_: a bug in the rust implementation, results in error
# assert_eq(int("0", base=8), 0)
# assert_eq(int("-0", base=8), 0)
# assert_eq(int("+0", base=8), 0)

assert_eq(int("00", base=8), 0)
assert_eq(int("-0"), 0)
assert_eq(int("-00"), 0)
assert_eq(int("-0", base=10), 0)
assert_eq(int("-00", base=10), 0)
assert_eq(int("-00", base=8), 0)
assert_eq(int("+0"), 0)
assert_eq(int("+00"), 0)
assert_eq(int("+0", base=10), 0)
assert_eq(int("+00", base=10), 0)
assert_eq(int("+00", base=8), 0)
assert_eq(int("11", base=9), 10)
assert_eq(int("-11", base=9), -10)
assert_eq(int("10011", base=2), 19)
assert_eq(int("-10011", base=2), -19)
assert_eq(int("123", 8), 83)
assert_eq(int("-123", 8), -83)
assert_eq(int("0123", 8), 83) # redundant zeros permitted
assert_eq(int("-0123", 8), -83)
assert_eq(int("00123", 8), 83)
assert_eq(int("-00123", 8), -83)
assert_eq(int("0o123", 8), 83)
assert_eq(int("-0o123", 8), -83)
assert_eq(int("123", 7), 66) # 1*7*7 + 2*7 + 3
assert_eq(int("-123", 7), -66)
assert_eq(int("12", 16), 18)
assert_eq(int("-12", 16), -18)
assert_eq(int("0x12", 16), 18)
assert_eq(int("-0x12", 16), -18)
assert_eq(0x1001 * 0x1001, 0x1002001)
assert_eq(int("1010", 2), 10)
assert_eq(int("111111101", 2), 509)
assert_eq(int("0b0101", 0), 5)
assert_eq(int("0b00000", 0), 0)
assert_eq(11111 * 11111, 123454321)

---
int("0x123", 8) ### (invalid literal.*base 8|not a base 8)
---
int("-0x123", 8) ### (invalid literal.*base 8|not a base 8)
---
int("0o123", 16) ### (invalid literal.*base 16|not a base 16)
---
int("-0o123", 16) ### (invalid literal.*base 16|not a base 16)
---
int("0x110", 2) ### (invalid literal.*base 2|not a base 2)
---
# int from string, auto detect base
assert_eq(int("123", 0), 123)
assert_eq(int("+123", 0), 123)
assert_eq(int("-123", 0), -123)
assert_eq(int("0x12", 0), 18)
assert_eq(int("+0x12", 0), 18)
assert_eq(int("-0x12", 0), -18)
assert_eq(int("0o123", 0), 83)
assert_eq(int("+0o123", 0), 83)
assert_eq(int("-0o123", 0), -83)
---

# _inconsistency_: valid in Rust and Python 2.7
# int("0123", 0) ## (invalid literal.*base 0|cannot infer base)
---
# int("-0123", 0) ## (invalid literal.*base 0|cannot infer base)
---


# github.com/google/starlark-go/issues/108
int("0Oxa", 8) ### (invalid literal|not a base 8)
---

# _inconsistency_: some implementations allow some of these conversions
# follow-on bugs to issue 108
# int("--4") ## invalid literal with base 10: --4
---
# int("++4") ## invalid literal with base 10: \+\+4
---
# int("+-4") ## invalid literal with base 10: \+-4
---
# int("0x-4", 16) ## invalid literal with base 16: 0x-4
---

# _inconsistency_: java does not support bitwise operations
# bitwise union (int|int), intersection (int&int), XOR (int^int), unary not (~int),
# left shift (int<<int), and right shift (int>>int).
# use resolve.AllowBitwise to enable the ops.
# TODO(adonovan): this is not yet in the Starlark spec,
# but there is consensus that it should be.
# assert_eq(1|2, 3)
# assert_eq(3|6, 7)
# assert_eq((1|2) & (2|4), 2)
# assert_eq(1 ^ 2, 3)
# assert_eq(2 ^ 2, 0)
# assert_eq(1 | 0 ^ 1, 1) # check | and ^ operators precedence
# assert_eq(~1, -2)
# assert_eq(~-2, 1)
# assert_eq(~0, -1)
# assert_eq(1 << 2, 4)
# assert_eq(2 >> 1, 1)
---
# 2 << -1 ## negative shift count
---
# 1 << 512 ## shift count too large
---

maxint32 = 2147483647
minint32 = -2147483647 - 1

# comparisons
def comparisons():
  for m in [1, maxint32//4, maxint32//2]: # Test small/big ranges
    assert_(-2*m < -1*m)
    assert_(-1*m < 0*m)
    assert_(0*m < 1*m)
    assert_(1*m < 2*m)
    assert_(2*m >= 2*m)
    assert_(2*m > 1*m)
    assert_(1*m >= 1*m)
    assert_(1*m > 0*m)
    assert_(0*m >= 0*m)
    assert_(0*m > -1*m)
    assert_(-1*m >= -1*m)
    assert_(-1*m > -2*m)

comparisons()

# precision
assert_eq(str(maxint32-1), "2147483646")
assert_eq(str(minint32+1), "-2147483647")
assert_eq(str(maxint32 // -1), "-2147483647")


# string formatting
nums = [-95, -1, 0, 1, 95]
assert_eq(' '.join(["%d" % x for x in nums]), "-95 -1 0 1 95")

# _inconsistency_: java doesn't support these format args
# assert_eq(' '.join(["%x" % x for x in nums]), "-5f -1 0 1 5f")
# assert_eq(' '.join(["%X" % x for x in nums]), "-5F -1 0 1 5F")
# assert_eq(' '.join(["%i" % x for x in nums]), "-95 -1 0 1 95")
# assert_eq(' '.join(["%o" % x for x in nums]), "-137 -1 0 1 137")
# assert_eq("%o %x %d" % (0o755, 0xDEADBEEF, 42), "755 deadbeef 42")
# assert_eq("%o %x %d" % (123, 123, 123), "173 7b 123")
---
# _inconsistency_: rust and python accepts this conversion
# "%d" % True ## (cannot convert bool to int|invalid argument)
