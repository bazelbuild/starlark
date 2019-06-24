# String tests


# From Starlark spec

# The conversion's operand is the next element of args, which must be a tuple
# with exactly one component per conversion,

assert_eq("ab1cd2ef", "ab%scd%sef" % [1, 2])

# ... unless the format string contains
# only a single conversion, in which case args itself is its operand.
assert_eq("ab[1]cd", "ab%scd" % [1])


# Issue #43
''%(0)     ###   (The type 'int' is not iterable|not enough arguments)
---
''%(0,)    ###   (Too many arguments for format string|not all arguments converted)
