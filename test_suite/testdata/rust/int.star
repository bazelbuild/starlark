# Integer tests

# _inconsistency_: int ranges is different among implementations
# 9223372036854775807 + 1      ##  Integer overflow
---
#-9223372036854775807 - 2     ##  Integer overflow
---
#9223372036854775807 * 2      ##  Integer overflow
---
#int_min = -9223372036854775807 - 1
#-int_min                     ##  Integer overflow
---
#int_min = -9223372036854775807 - 1
#int_min // -1                ##  Integer overflow
---
int_min = -2147483647 - 1
int_max = 2147483647

assert_eq(0, int_min % -1)
assert_eq(0, int_min % int_min)
assert_eq(2147483646, int_min % int_max)
assert_eq(-1, int_max % int_min)


# Issue #98
assert_eq(4, 7 - 2 - 1)
