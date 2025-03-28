# Regression for https://github.com/google/starlark-rust/issues/10
"abc" * True  ### (Type of parameters mismatch|unknown binary op|unsupported|not supported)
---
# Make sure int * string works as well as string * int
assert_eq(3 * "abc", "abcabcabc")
assert_eq("abc" * 3, "abcabcabc")
