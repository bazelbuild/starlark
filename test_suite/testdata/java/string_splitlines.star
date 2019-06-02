# Empty line
assert_eq(''.splitlines(), [])
assert_eq('\n'.splitlines(), [''])

# Starts with line break
assert_eq('\ntest'.splitlines(), ['', 'test'])

# Ends with line break
assert_eq('test\n'.splitlines(), ['test'])

# Different line breaks
assert_eq('this\nis\na\ntest'.splitlines(), ['this', 'is', 'a', 'test'])

# _inconsistency_: go splits on \n only
# Only line breaks
# assert_eq('\r\r\r'.splitlines(), ['', '', ''])
# assert_eq('\n\r\n\r'.splitlines(), ['', '', ''])
# assert_eq('\r\n\r\n\r\n'.splitlines(), ['', '', ''])
assert_eq('\n\n\n'.splitlines(), ['', '', ''])

# Escaped sequences
assert_eq('\n\\n\\\n'.splitlines(), ['', '\\n\\'])

# KeepEnds
assert_eq(''.splitlines(True), [])
assert_eq('\n'.splitlines(True), ['\n'])
assert_eq('this\nis\na\ntest'.splitlines(True), ['this\n', 'is\n', 'a\n', 'test'])
assert_eq('\ntest'.splitlines(True), ['\n', 'test'])
assert_eq('test\n'.splitlines(True), ['test\n'])
assert_eq('\n\\n\\\n'.splitlines(True), ['\n', '\\n\\\n'])

# _inconsistency_: go splits on \n only
# assert_eq('this\nis\r\na\rtest'.splitlines(True), ['this\n', 'is\r\n', 'a\r', 'test'])
