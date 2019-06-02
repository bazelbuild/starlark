assert_eq('abc'.format(), "abc")

# named arguments
assert_eq('x{key}x'.format(key = 2), "x2x")
assert_eq('x{key}x'.format(key = 'abc'), "xabcx")
assert_eq('{a}{b}{a}{b}'.format(a = 3, b = True), "3True3True")
assert_eq('{a}{b}{a}{b}'.format(a = 3, b = True), "3True3True")
assert_eq('{s1}{s2}'.format(s1 = ['a'], s2 = 'a'), "[\"a\"]a")
assert_eq('{a}'.format(a = '$'), "$")
assert_eq('{a}'.format(a = '$a'), "$a")
assert_eq('{a}$'.format(a = '$a'), "$a$")
assert_eq('{(}'.format(**{'(': 2}), "2")

# curly brace escaping
assert_eq('{{}}'.format(), "{}")
assert_eq('{{}}'.format(42), "{}")
assert_eq('{{ }}'.format(), "{ }")
assert_eq('{{ }}'.format(42), "{ }")
assert_eq('{{{{}}}}'.format(), "{{}}")
assert_eq('{{{{}}}}'.format(42), "{{}}")
assert_eq('{{0}}'.format(42), "{0}")
assert_eq('{{}}'.format(42), "{}")
assert_eq('{{{}}}'.format(42), "{42}")
assert_eq('{{ '.format(42), "{ " )
assert_eq(' }}'.format(42), " }")
assert_eq('{{ {}'.format(42), "{ 42")
assert_eq('{} }}'.format(42), "42 }")
assert_eq('{{0}}'.format(42), "{0}")
assert_eq('{{{0}}}'.format(42), "{42}")
assert_eq('{{ 0'.format(42), "{ 0")
assert_eq('0 }}'.format(42), "0 }")
assert_eq('{{ {0}'.format(42), "{ 42")
assert_eq('{0} }}'.format(42), "42 }")
assert_eq('{{test}}'.format(test = 42), "{test}")
assert_eq('{{{test}}}'.format(test = 42), "{42}")
assert_eq('{{ test'.format(test = 42), "{ test")
assert_eq('test }}'.format(test = 42), "test }")
assert_eq('{{ {test}'.format(test = 42), "{ 42")
assert_eq('{test} }}'.format(test = 42), "42 }")


# Automatic positionals
assert_eq('{}, {} {} {} test'.format('hi', 'this', 'is', 'a'), "hi, this is a test")
assert_eq('skip some {}'.format('arguments', 'obsolete', 'deprecated'), "skip some arguments")

# with numbered positions
assert_eq('{0}, {1} {2} {3} test'.format('hi', 'this', 'is', 'a'), "hi, this is a test")
assert_eq('{3}, {2} {1} {0} test'.format('a', 'is', 'this', 'hi'), "hi, this is a test")
assert_eq('skip some {0}'.format('arguments', 'obsolete', 'deprecated'), "skip some arguments")
assert_eq('{0} can be reused: {0}'.format('this', 'obsolete'), "this can be reused: this")

# Mixed fields
assert_eq('{test} and {}'.format(2, test = 1), "1 and 2")
assert_eq('{test} and {0}'.format(2, test = 1), "1 and 2")

---
'{{}'.format(1) ### (Found '}' without matching '{'|single '}')
---
'{}}'.format(1) ### (Found '}' without matching '{'|single '}')
---
'{0}'.format() ### (No replacement found for index 0|index out of range)
---
'{0} and {1}'.format('this') ### (No replacement found for index 1|index out of range)
---
'{0} and {2}'.format('this', 'that') ### (No replacement found for index 2|index out of range)
---
# _inconsistency_: -0 not allowed in go,rust, different error
# '{-0} and {-1}'.format('this', 'that') ##
---
'{0,1} and {1}'.format('this', 'that') ### (Invalid character ',' inside replacement field|not found)
---
'{0.1} and {1}'.format('this', 'that') ### (Invalid character '.' inside replacement field|not supported)
---
'{}'.format() ### (No replacement found for index 0|index out of range)
---
'{} and {}'.format('this') ### (No replacement found for index 1|index out of range)
---
'{test} and {}'.format(test = 1, 2) ### positional argument
---
'{test} and {0}'.format(test = 1, 2) ### positional argument
---
'{} and {1}'.format(1, 2) ### Cannot (mix|switch)
---
'{1} and {}'.format(1, 2) ### Cannot (mix|switch)
---
'{test.}'.format(test = 1) ### (Invalid character '.' inside replacement field|not supported)
---
'{test[}'.format(test = 1) ### (Invalid character '\[' inside replacement field|not supported)
---
'{test,}'.format(test = 1) ### (Invalid character ',' inside replacement field|not found)
---
'{ {} }'.format(42) ### Nested replacement fields
---
'{a}{b}'.format(a = 5) ### (Missing argument 'b'|keyword b not found)
