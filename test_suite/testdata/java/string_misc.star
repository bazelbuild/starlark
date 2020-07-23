# join
assert_eq('-'.join(['a', 'b', 'c']), "a-b-c")

---
join(' ', ['a', 'b', 'c']) ### (name 'join' is not defined|undefined|not found)
---

assert_eq(''.join([(x + '*') for x in ['a', 'b', 'c']]), "a*b*c*")
li = [(y + '*' + z + '|') for y in ['a', 'b', 'c'] for z in ['d', 'e']]
assert_eq(''.join(li), "a*d|a*e|b*d|b*e|c*d|c*e|")

# lower, upper
assert_eq('Blah Blah'.lower(), "blah blah")
assert_eq('ein bier'.upper(), "EIN BIER")
assert_eq(''.upper(), "")

# title
assert_eq('this is a very simple test'.title(), "This Is A Very Simple Test")
assert_eq('Do We Keep Capital Letters?'.title(), "Do We Keep Capital Letters?")
assert_eq("this isn't just an ol' apostrophe test".title(),
          "This Isn'T Just An Ol' Apostrophe Test")
assert_eq('Let us test crazy characters: _bla.exe//foo:bla(test$class)'.title(),
          "Let Us Test Crazy Characters: _Bla.Exe//Foo:Bla(Test$Class)")
assert_eq('WE HAve tO lOWERCASE soMEthING heRE, AI?'.title(),
          "We Have To Lowercase Something Here, Ai?")
assert_eq('wh4t ab0ut s0me numb3rs'.title(), "Wh4T Ab0Ut S0Me Numb3Rs")

# _inconsistency_: rust's capitalize() implementation is different from go, java
# capitalize
# assert_eq('hello world'.capitalize(), "Hello world")
# assert_eq('HELLO WORLD'.capitalize(), "Hello world")
# assert_eq('12 lower UPPER 34'.capitalize(), "12 lower upper 34")

assert_eq(''.capitalize(), "")


# replace
assert_eq('banana'.replace('a', 'e'), "benene")
assert_eq('banana'.replace('a', '$()'), "b$()n$()n$()")
assert_eq('banana'.replace('a', '$'), "b$n$n$")
assert_eq('banana'.replace('a', '\\'), "b\\n\\n\\")
assert_eq('b$()n$()n$()'.replace('$()', '$($())'), "b$($())n$($())n$($())")
assert_eq('b\\n\\n\\'.replace('\\', '$()'), "b$()n$()n$()")

assert_eq('banana'.replace('a', 'e', 2), "benena")

# index, rindex
assert_eq('banana'.index('na'), 2)
assert_eq('abababa'.index('ab', 1), 2)
assert_eq('banana'.rindex('na'), 4)
assert_eq('abababa'.rindex('ab', 1), 4)
---
'banana'.index('foo') ### substring (\"foo\" )?not found
---
'banana'.rindex('foo') ### substring (\"foo\" )?not found
---

# endswith
assert_eq('Apricot'.endswith('cot'), True)
assert_eq('a'.endswith(''), True)
assert_eq(''.endswith(''), True)
assert_eq('Apricot'.endswith('co'), False)

# _inconsistency_: rust endwith() accepts only a single argument
# assert_eq('Apricot'.endswith('co', -1), False)
# assert_eq('abcd'.endswith('c', -2, -1), True)
# assert_eq('abcd'.endswith('c', 1, 8), False)
# assert_eq('abcd'.endswith('d', 1, 8), True)
# assert_eq('Apricot'.endswith(('cot', 'toc')), True)
# assert_eq('Apricot'.endswith(('toc', 'cot')), True)
# assert_eq('a'.endswith(('', '')), True)
# assert_eq('a'.endswith(('', 'a')), True)
# assert_eq('a'.endswith(('a', 'a')), True)
# assert_eq(''.endswith(('a', '')), True)
# assert_eq(''.endswith(('', '')), True)
# assert_eq(''.endswith(('a', 'a')), False)
# assert_eq('a'.endswith(('a')), True)
# assert_eq('a'.endswith(('a',)), True)
# assert_eq('a'.endswith(('b',)), False)
# assert_eq('a'.endswith(()), False)
# assert_eq(''.endswith(()), False)
---
'a'.endswith(['a']) ### (got value of type 'list'|got list|parameters mismatch)
---
'1'.endswith((1,)) ### (want string|got int|parameters mismatch)
---
'a'.endswith(('1', 1)) ### (want string|got int|parameters mismatch)
---

# startswith
assert_eq('Apricot'.startswith('Apr'), True)
assert_eq('Apricot'.startswith('A'), True)
assert_eq('Apricot'.startswith(''), True)
assert_eq('Apricot'.startswith('z'), False)
assert_eq(''.startswith(''), True)
assert_eq(''.startswith('a'), False)

# _inconsistency_: rust startswith() accepts only a single argument
# assert_eq('Apricot'.startswith(('Apr', 'rpA')), True)
# assert_eq('Apricot'.startswith(('rpA', 'Apr')), True)
# assert_eq('a'.startswith(('', '')), True)
# assert_eq('a'.startswith(('', 'a')), True)
# assert_eq('a'.startswith(('a', 'a')), True)
# assert_eq(''.startswith(('a', '')), True)
# assert_eq(''.startswith(('', '')), True)
# assert_eq(''.startswith(('a', 'a')), False)
# assert_eq('a'.startswith(('a')), True)
# assert_eq('a'.startswith(('a',)), True)
# assert_eq('a'.startswith(('b',)), False)
# assert_eq('a'.startswith(()), False)
# assert_eq(''.startswith(()), False)
---
'a'.startswith(['a']) ### (got.*want|got list|expected string)
---
'1'.startswith((1,)) ### (got.*want|got int|expected string)
---
'a'.startswith(('1', 1)) ### (got.*want|got int|expected string)
---

# substring
assert_eq('012345678'[0:-1], "01234567")
assert_eq('012345678'[2:4], "23")
assert_eq('012345678'[-5:-3], "45")
assert_eq('012345678'[2:2], "")
assert_eq('012345678'[2:], "2345678")
assert_eq('012345678'[:3], "012")
assert_eq('012345678'[-1:], "8")
assert_eq('012345678'[:], "012345678")
assert_eq('012345678'[-1:2], "")
assert_eq('012345678'[4:2], "")

# count
assert_eq('abc'.count('a'), 1)
assert_eq('abc'.count('b'), 1)
assert_eq('abc'.count('c'), 1)
assert_eq('abbc'.count('b'), 2)
assert_eq('aba'.count('a'), 2)
assert_eq('aaa'.count('aa'), 1)
assert_eq('aaaa'.count('aa'), 2)
assert_eq('abc'.count('a', 0), 1)
assert_eq('abc'.count('a', 1), 0)
assert_eq('abc'.count('c', 0, 3), 1)
assert_eq('abc'.count('c', 0, 2), 0)
assert_eq('abc'.count('a', -1), 0)
assert_eq('abc'.count('c', -1), 1)
assert_eq('abc'.count('c', 0, 5), 1)
assert_eq('abc'.count('c', 0, -1), 0)
assert_eq('abc'.count('a', 0, -1), 1)

# isalpha
assert_eq(''.isalpha(), False)
assert_eq('abz'.isalpha(), True)
assert_eq('a1'.isalpha(), False)
assert_eq('a '.isalpha(), False)
assert_eq('A'.isalpha(), True)
assert_eq('AbZ'.isalpha(), True)
