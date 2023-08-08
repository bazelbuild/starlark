# Tests of Skylark 'int'

# basic arithmetic
assert_eq(0 - 1, -1)
assert_eq(1 + 1, 2)
assert_eq(5 + 7, 12)
assert_eq(5 * 7, 35)
assert_eq(5 - 7, -2)

# truth
assert_(123)
assert_(-1)
assert_(not 0)

# comparisons
assert_(5 > 2)
assert_(2 + 1 == 3)
assert_(2 + 1 >= 3)
assert_(not (2 + 1 > 3))
assert_(2 + 2 <= 5)
assert_(not (2 + 1 < 3))

# division
assert_eq(100 // 7, 14)
assert_eq(100 // -7, -15)
assert_eq(-100 // 7, -15) # NB: different from Go / Java
assert_eq(-100 // -7, 14) # NB: different from Go / Java
assert_eq(98 // 7, 14)
assert_eq(98 // -7, -14)
assert_eq(-98 // 7, -14)
assert_eq(-98 // -7, 14)

# remainder
assert_eq(100 % 7, 2)
assert_eq(100 % -7, -5) # NB: different from Go / Java
assert_eq(-100 % 7, 5) # NB: different from Go / Java
assert_eq(-100 % -7, -2)
assert_eq(98 % 7, 0)
assert_eq(98 % -7, 0)
assert_eq(-98 % 7, 0)
assert_eq(-98 % -7, 0)

# precedence
assert_eq(5 - 7 * 2 + 3, -6)
assert_eq(4 * 5 // 2 + 5 // 2 * 4, 18)

# compound assignment
def compound():
  x = 1
  x += 1
  assert_eq(x, 2)
  x -= 3
  assert_eq(x, -1)
  x *= 10
  assert_eq(x, -10)
  x //= -2
  assert_eq(x, 5)
  x %= 3
  assert_eq(x, 2)

compound()

---
1 // 0  ### (division by zero|divide by zero)
---
1 % 0  ### by zero
