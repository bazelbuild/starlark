# Tests of Starlark 'bool'


# truth
assert_(True)
assert_(not False)
assert_(not not True)
assert_(not not 1 >= 1)

# bool conversion
assert_eq(
    [bool(False), bool(1), bool(0), bool("hello"), bool("")],
    [False, True, False, True, False],
)

# comparison
assert_(None == None)
assert_(None != False)
assert_(None != True)
assert_eq(1 == 1, True)
assert_eq(1 == 2, False)
assert_(False == False)
assert_(True == True)

# ordered comparison
assert_(False < True)
assert_(False <= True)
assert_(False <= False)
assert_(True > False)
assert_(True >= False)
assert_(True >= True)

# conditional expression
assert_eq(1 if 3 > 2 else 0, 1)
assert_eq(1 if "foo" else 0, 1)
assert_eq(1 if "" else 0, 0)

# short-circuit evaluation of 'and' and 'or':
# 'or' yields the first true operand, or the last if all are false.
assert_eq(0 or "" or [] or 0, 0)
assert_eq(0 or "" or [] or 123 or 1 // 0, 123)
---
0 or "" or [] or 0 or 1 // 0 ### (division by zero|divide by zero)
---

# 'and' yields the first false operand, or the last if all are true.
assert_eq(1 and "a" and [1] and 123, 123)
assert_eq(1 and "a" and [1] and 0 and 1 // 0, 0)
---
1 and "a" and [1] and 123 and 1 // 0 ### (division by zero|divide by zero)
---

# Built-ins that want a bool want an actual bool, not a truth value.
# See github.com/bazelbuild/starlark/issues/30
assert_eq(''.splitlines(True), [])
---
''.splitlines(1) ### (got.*want|expected bool|type of parameter.*doesn't match)
---
''.splitlines("hello") ### (got.*want|expected bool|type of parameter.*doesn't match)
