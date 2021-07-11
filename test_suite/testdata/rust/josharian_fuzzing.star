# This file contains the list of example reported by https://github.com/josharian
# as part of his fuzzing of starlark-rust

# _inconsistency_: java requires whitespace between some tokens
# https://github.com/google/starlark-rust/issues/44: whitespace isn't required between some tokens
# assert_eq(6or(), 6)

---
# 6burgle still generates a parse error.
6burgle  ### (parse error|got identifier, want newline|syntax error)
---
# https://github.com/google/starlark-rust/issues/56: Non whitespace after 0 should be allowed.
assert_eq(0in[1,2,3], False)
---
# _inconsistency_: go and java return different values for these corner cases
# https://github.com/google/starlark-rust/issues/61: panic on bad range using string.index
# assert_eq('a'.find('', 1, 0), -1)
# assert_eq('a'.rfind('', 1, 0), -1)
---
# 'a'.index('', 1, 0)  ## [UF00]
---
# 'a'.rindex('', 1, 0)  ## [UF00]
---
# https://github.com/google/starlark-rust/issues/64: alphabetize dir entries
assert_eq(dir(""), sorted(dir("")))
---
# _inconsistency_: starlark spec allows floats and '/' operator; currently, only Java
# implementation supports it.
# 1 / 1
