# Tests of Starlark 'string'


# raw string literals:
assert_eq(r'a\bc', "a\\bc")

# truth
assert_("abc")
assert_("\0")
assert_(not "")

# str + str
assert_eq("a"+"b"+"c", "abc")

# str * int,  int * str
assert_eq("abc" * 0, "")
assert_eq("abc" * -1, "")
assert_eq("abc" * 1, "abc")
assert_eq("abc" * 5, "abcabcabcabcabc")
assert_eq(0 * "abc", "")
assert_eq(-1 * "abc", "")
assert_eq(1 * "abc", "abc")
assert_eq(5 * "abc", "abcabcabcabcabc")
# _inconsistency_: java supports up to 32 bit ints only
# assert.fails(lambda : "abc" * (1000000 * 1000000), "repeat count 1000000000000 too large")
# assert.fails(lambda : "abc" * 1000000 * 1000000, "excessive repeat .3000000000000 elements")
---

# len
# _inconsistency_: rust returns 10 given this unicode string
# assert_eq(len("Hello, 世界!"), 14)
# assert_eq(len("𐐷"), 4) # U+10437 has a 4-byte UTF-8 encoding (and a 2-code UTF-16 encoding)


# _inconsistency_: chr and ord not implemented in Java
# chr & ord
# assert_eq(chr(65), "A")       # 1-byte UTF-8 encoding
# assert_eq(chr(1049), "Й")     # 2-byte UTF-8 encoding
# assert_eq(chr(0x1F63F), "😿") # 4-byte UTF-8 encoding
---
# chr(-1) ## Unicode code point -1 out of range \(<0\)
---
# chr(0x110000) ## Unicode code point U\+110000 out of range \(>0x10FFFF\)
---
# assert_eq(ord("A"), 65)
# assert_eq(ord("Й"), 1049)
# assert_eq(ord("😿"), 0x1F63F)
# assert_eq(ord("Й"[1:]), 0xFFFD) # = Unicode replacement character
---
# ord("abc") ## string encodes 3 Unicode code points, want 1
---
# ord("") ## string encodes 0 Unicode code points, want 1
---
# ord("😿"[1:]) ## string encodes 3 Unicode code points, want 1
---

# _inconsistency_: codepoints and codepoint_ords not implemented in Java
# string.codepoint_ords
# assert_eq(type("abcЙ😿".codepoint_ords()), "codepoints")
# assert_eq(str("abcЙ😿".codepoint_ords()), '"abcЙ😿".codepoint_ords()')
# assert_eq(list("abcЙ😿".codepoint_ords()), [97, 98, 99, 1049, 128575])
# assert_eq(list(("A" + "😿Z"[1:]).codepoint_ords()), [ord("A"), 0xFFFD, 0xFFFD, 0xFFFD, ord("Z")])
# assert_eq(list("".codepoint_ords()), [])

# string.codepoints
# assert_eq(type("abcЙ😿".codepoints()), "codepoints")
# assert_eq(str("abcЙ😿".codepoints()), '"abcЙ😿".codepoints()')
# assert_eq(list("abcЙ😿".codepoints()), ["a", "b", "c", "Й", "😿"])
# assert_eq(list(("A" + "😿Z"[1:]).codepoints()), ["A", "\x9f", "\x98", "\xbf", "Z"])
# assert_eq(list("".codepoints()), [])

# _inconsistency_: elem_ords not implemented in Java
# string.elem_ords
# assert_eq(type("abcЙ😿".elem_ords()), "elems")
# assert_eq(str("abcЙ😿".elem_ords()), '"abcЙ😿".elem_ords()')
# assert_eq(list("abcЙ😿".elem_ords()), [97, 98, 99,  208, 153, 240, 159, 152, 191])
# assert_eq(list(("A" + "😿Z"[1:]).elem_ords()),  [65, 159, 152, 191, 90])
# assert_eq(list("".elem_ords()), [])

# _inconsistency_: elems in rust performs the functionality of elem_ords in Go
# string.elems
# assert_eq(type("abcЙ😿".elems()), "elems")
# assert_eq(str("abcЙ😿".elems()), '"abcЙ😿".elems()')
# assert_eq(list("abcЙ😿".elems()),
#          ["a", "b", "c", "\xd0", "\x99", "\xf0", "\x9f", "\x98", "\xbf"])
# assert_eq(list(("A" + "😿Z"[1:]).elems()),
#          ["A", "\x9f", "\x98", "\xbf", "Z"])
# assert_eq(list("".elems()), [])

# indexing, x[i]
assert_eq("Hello, 世界!"[0], "H")

# _inconsistency_: indices with unicode strings are different in rust
# assert_eq("Hello, 世界!"[7], "\xe4")
# assert_eq("Hello, 世界!"[13], "!")
---
"abc"[-4] ### out of (range|bound)
---
assert_eq("abc"[-3], "a")
assert_eq("abc"[-2], "b")
assert_eq("abc"[-1], "c")
assert_eq("abc"[0], "a")
assert_eq("abc"[1], "b")
assert_eq("abc"[2], "c")
---
"abc"[4] ### out of (range|bound)
---

# x[i] = ...
x2 = "abc"
def f(): x2[1] = 'B'
f() ### (string.*does not support.*assignment|not supported|can only assign an element in a dictionary or a list|immutable)
---

# slicing, x[i:j]
assert_eq("abc"[:], "abc")
assert_eq("abc"[-4:], "abc")
assert_eq("abc"[-3:], "abc")
assert_eq("abc"[-2:], "bc")
assert_eq("abc"[-1:], "c")
assert_eq("abc"[0:], "abc")
assert_eq("abc"[1:], "bc")
assert_eq("abc"[2:], "c")
assert_eq("abc"[3:], "")
assert_eq("abc"[4:], "")
assert_eq("abc"[:-4], "")
assert_eq("abc"[:-3], "")
assert_eq("abc"[:-2], "a")
assert_eq("abc"[:-1], "ab")
assert_eq("abc"[:0], "")
assert_eq("abc"[:1], "a")
assert_eq("abc"[:2], "ab")
assert_eq("abc"[:3], "abc")
assert_eq("abc"[:4], "abc")
assert_eq("abc"[1:2], "b")
assert_eq("abc"[2:1], "")
# non-unit strides
assert_eq("abcd"[0:4:1], "abcd")
assert_eq("abcd"[::2], "ac")
assert_eq("abcd"[1::2], "bd")
assert_eq("abcd"[4:0:-1], "dcb")
assert_eq("banana"[7::-2], "aaa")
assert_eq("banana"[6::-2], "aaa")
assert_eq("banana"[5::-2], "aaa")
assert_eq("banana"[4::-2], "nnb")
assert_eq("banana"[::-1], "ananab")
assert_eq("banana"[None:None:-2], "aaa")
---
"banana"[:"":] ### (got.*want|parameters mismatch)
---
"banana"[:"":True] ### (got.*want|parameters mismatch)
---

# in, not in
assert_("oo" in "food")
assert_("ox" not in "food")
assert_("" in "food")
assert_("" in "")
---
1 in "" ### (requires string as left operand|parameters mismatch)
---
"" in 1 ### ((unknown|unsupported) binary op|not supported)
---

# ==, !=
assert_eq("hello", "he"+"llo")
assert_ne("hello", "Hello")

# hash must follow java.lang.String.hashCode.
wanthash = {
    "": 0,
    "\0" * 100: 0,
    "hello": 99162322,
    "world": 113318802,
    "Hello, 世界!": 417292677,
}
gothash = {s: hash(s) for s in wanthash}

# _inconsistency_: rust hash function does not work the same as Go and Java
# assert_eq(gothash, wanthash)


# string % tuple formatting

# _inconsistency_: java doesn't suppor formatting arg %x nor %(key)
# assert_eq("A %d %x Z" % (123, 456), "A 123 1c8 Z")
# assert_eq("A %(foo)d %(bar)s Z" % {"foo": 123, "bar":"hi"}, "A 123 hi Z")
assert_eq("%s %r" % ("hi", "hi"), 'hi "hi"')
assert_eq("%%d %d" % 1, "%d 1")
---
"%d %d" % 1 ### (not enough arguments|not iterable|operation.*not supported)
---
"%d %d" % (1, 2, 3) ### (too many arguments for format string|not all arguments converted)
---
"" % 1 ### (too many arguments for format string|not all arguments converted|not iterable|operation.*not supported)
---
# _inconsistency_: java doesn't support format character %c
# %c
# assert_eq("%c" % 65, "A")
# assert_eq("%c" % 0x3b1, "α")
# assert_eq("%c" % "A", "A")
# assert_eq("%c" % "α", "α")
---
# "%c" % "abc" ## requires a single-character string
---
# "%c" % "" ## requires a single-character string
---
# "%c" % 10000000 ## requires a valid Unicode code point
---
# "%c" % -1 ## requires a valid Unicode code point
---

# str.formatx
assert_eq("a{}b".format(123), "a123b")
assert_eq("a{}b{}c{}d{}".format(1, 2, 3, 4), "a1b2c3d4")
assert_eq("a{{b".format(), "a{b")
assert_eq("a}}b".format(), "a}b")
assert_eq("a{{b}}c".format(), "a{b}c")
assert_eq("a{x}b{y}c{}".format(1, x=2, y=3), "a2b3c1")
---
"a{z}b".format(x=1) ### (not found|missing argument)
---
"{-1}".format(1) ### (not found|no replacement found)
---
# _inconsistency_: java accepts {-0}
# "{-0}".format(1) ## not found
---
"{+0}".format(1) ### (not found|missing argument)
---
# starlark-go/issues/114
"{+1}".format(1) ### (not found|missing argument)
---
assert_eq("{0000000000001}".format(0, 1), "1")
assert_eq("{012}".format(*range(100)), "12") # decimal, despite leading zeros
---
'{0,1} and {1}'.format(1, 2) ### (keyword 0,1 not found|missing argument|invalid character)
---
"a{123}b".format() ### (tuple index out of range|no replacement found|out of bound)
---
"a{}b{}c".format(1) ### (tuple index out of range|no replacement found|not enough parameters)
---
assert_eq("a{010}b".format(0,1,2,3,4,5,6,7,8,9,10), "a10b") # index is decimal
---
"a{}b{1}c".format(1, 2) ### (cannot switch from automatic field numbering to manual|manual.* and automatic.*)
---
# _inconsistency_: java doesn't support '!' in format
# assert_eq("a{!s}c".format("b"), "abc")
# assert_eq("a{!r}c".format("b"), r'a"b"c')
# assert_eq("a{x!r}c".format(x='b'), r'a"b"c')
---
# "{x!}".format(x=1) ## unknown conversion
---
# "{x!:}".format(x=1) ## unknown conversion
---
'{a.b}'.format(1) ### (syntax x.y is not supported|invalid character)
---
'{a[0]}'.format(1) ### (syntax a\[i\] is not supported|invalid character)
---
'{ {} }'.format(1) ### (nested replacement fields.*not supported|unmatched)
---
'{{}'.format(1) ### (single '}' in format|found.*without matching|standalone)
---
'{}}'.format(1) ### (single '}' in format|found.*without matching|standalone)
---
'}}{'.format(1) ### (unmatched '{' in format|found.*without matching)
---
'}{{'.format(1) ### (single '}' in format|found.*without matching|standalone)
---

# str.split, str.rsplit
assert_eq("a.b.c.d".split("."), ["a", "b", "c", "d"])
assert_eq("a.b.c.d".rsplit("."), ["a", "b", "c", "d"])
assert_eq("a.b.c.d".split(".", -1), ["a", "b", "c", "d"])
assert_eq("a.b.c.d".rsplit(".", -1), ["a", "b", "c", "d"])
assert_eq("a.b.c.d".split(".", 0), ["a.b.c.d"])
assert_eq("a.b.c.d".rsplit(".", 0), ["a.b.c.d"])
assert_eq("a.b.c.d".split(".", 1), ["a", "b.c.d"])
assert_eq("a.b.c.d".rsplit(".", 1), ["a.b.c", "d"])
assert_eq("a.b.c.d".split(".", 2), ["a", "b", "c.d"])
assert_eq("a.b.c.d".rsplit(".", 2), ["a.b", "c", "d"])
assert_eq("  ".split("."), ["  "])
assert_eq("  ".rsplit("."), ["  "])

# {,r}split on white space:
# _inconsistency_: java has no default parameter for split() and does not accept None
# assert_eq(" a bc\n  def \t  ghi".split(), ["a", "bc", "def", "ghi"])
# assert_eq(" a bc\n  def \t  ghi".split(None), ["a", "bc", "def", "ghi"])
# assert_eq(" a bc\n  def \t  ghi".split(None, 0), ["a bc\n  def \t  ghi"])
# assert_eq(" a bc\n  def \t  ghi".rsplit(None, 0), [" a bc\n  def \t  ghi"])
# assert_eq(" a bc\n  def \t  ghi".split(None, 1), ["a", "bc\n  def \t  ghi"])
# assert_eq(" a bc\n  def \t  ghi".rsplit(None, 1), [" a bc\n  def", "ghi"])
# assert_eq(" a bc\n  def \t  ghi".split(None, 2), ["a", "bc", "def \t  ghi"])
# assert_eq(" a bc\n  def \t  ghi".rsplit(None, 2), [" a bc", "def", "ghi"])
# assert_eq(" a bc\n  def \t  ghi".split(None, 3), ["a", "bc", "def", "ghi"])
# assert_eq(" a bc\n  def \t  ghi".rsplit(None, 3), [" a", "bc", "def", "ghi"])
# assert_eq(" a bc\n  def \t  ghi".split(None, 4), ["a", "bc", "def", "ghi"])
# assert_eq(" a bc\n  def \t  ghi".rsplit(None, 4), ["a", "bc", "def", "ghi"])
# assert_eq(" a bc\n  def \t  ghi".rsplit(None, 5), ["a", "bc", "def", "ghi"])

# assert_eq(" a bc\n  def \t  ghi ".split(None, 0), ["a bc\n  def \t  ghi "])
# assert_eq(" a bc\n  def \t  ghi ".rsplit(None, 0), [" a bc\n  def \t  ghi"])
# assert_eq(" a bc\n  def \t  ghi ".split(None, 1), ["a", "bc\n  def \t  ghi "])
# assert_eq(" a bc\n  def \t  ghi ".rsplit(None, 1), [" a bc\n  def", "ghi"])

# Observe the algorithmic difference when splitting on spaces versus other delimiters.
assert_eq('--aa--bb--cc--'.split('-', 0), ['--aa--bb--cc--'])  # contrast this
# assert_eq('  aa  bb  cc  '.split(None, 0), ['aa  bb  cc  '])   #  with this
assert_eq('--aa--bb--cc--'.rsplit('-', 0), ['--aa--bb--cc--']) # ditto this
# assert_eq('  aa  bb  cc  '.rsplit(None, 0), ['  aa  bb  cc'])  #  and this
#
assert_eq('--aa--bb--cc--'.split('-', 1), ['', '-aa--bb--cc--'])
assert_eq('--aa--bb--cc--'.rsplit('-', 1), ['--aa--bb--cc-', ''])
# assert_eq('  aa  bb  cc  '.split(None, 1), ['aa', 'bb  cc  '])
# assert_eq('  aa  bb  cc  '.rsplit(None, 1), ['  aa  bb',  'cc'])
#
assert_eq('--aa--bb--cc--'.split('-', -1), ['', '', 'aa', '', 'bb', '', 'cc', '', ''])
assert_eq('--aa--bb--cc--'.rsplit('-', -1), ['', '', 'aa', '', 'bb', '', 'cc', '', ''])
# assert_eq('  aa  bb  cc  '.split(None, -1), ['aa', 'bb', 'cc'])
# assert_eq('  aa  bb  cc  '.rsplit(None, -1), ['aa', 'bb', 'cc'])
# assert_eq('  '.split(None), [])
# assert_eq('  '.rsplit(None), [])

assert_eq("localhost:80".rsplit(":", 1)[-1], "80")

# str.splitlines
assert_eq('\nabc\ndef'.splitlines(), ['', 'abc', 'def'])
assert_eq('\nabc\ndef'.splitlines(True), ['\n', 'abc\n', 'def'])
assert_eq('\nabc\ndef\n'.splitlines(), ['', 'abc', 'def'])
assert_eq('\nabc\ndef\n'.splitlines(True), ['\n', 'abc\n', 'def\n'])
assert_eq(''.splitlines(), []) #
assert_eq(''.splitlines(True), []) #
assert_eq('a'.splitlines(), ['a'])
assert_eq('a'.splitlines(True), ['a'])
assert_eq('\n'.splitlines(), [''])
assert_eq('\n'.splitlines(True), ['\n'])
assert_eq('a\n'.splitlines(), ['a'])
assert_eq('a\n'.splitlines(True), ['a\n'])
assert_eq('a\n\nb'.splitlines(), ['a', '', 'b'])
assert_eq('a\n\nb'.splitlines(True), ['a\n', '\n', 'b'])
assert_eq('a\nb\nc'.splitlines(), ['a', 'b', 'c'])
assert_eq('a\nb\nc'.splitlines(True), ['a\n', 'b\n', 'c'])
assert_eq('a\nb\nc\n'.splitlines(), ['a', 'b', 'c'])
assert_eq('a\nb\nc\n'.splitlines(True), ['a\n', 'b\n', 'c\n'])

# str.{,l,r}strip
assert_eq(" \tfoo\n ".strip(), "foo")
assert_eq(" \tfoo\n ".lstrip(), "foo\n ")
assert_eq(" \tfoo\n ".rstrip(), " \tfoo")

# _inconsistency_: rust strip doesn't accept any args
# assert_eq(" \tfoo\n ".strip(""), "foo")
# assert_eq(" \tfoo\n ".lstrip(""), "foo\n ")
# assert_eq(" \tfoo\n ".rstrip(""), " \tfoo")
# assert_eq("blah.h".strip("b.h"), "la")
# assert_eq("blah.h".lstrip("b.h"), "lah.h")
# assert_eq("blah.h".rstrip("b.h"), "bla")

# str.count
assert_eq("banana".count("a"), 3)
assert_eq("banana".count("a", 2), 2)
assert_eq("banana".count("a", -4, -2), 1)
assert_eq("banana".count("a", 1, 4), 2)
assert_eq("banana".count("a", 0, -100), 0)

# str.{starts,ends}with
assert_("foo".endswith("oo"))
assert_(not "foo".endswith("x"))
assert_("foo".startswith("fo"))
assert_(not "foo".startswith("x"))
---
"foo".startswith(1) ### (got.*want|expected string|type of parameter.*doesn't match)
---
assert_('abc'.startswith(('a', 'A')))
assert_('ABC'.startswith(('a', 'A')))
assert_(not 'ABC'.startswith(('b', 'B')))
---
'123'.startswith((1, 2)) ### (got int, for element 0|type of parameter.*doesn't match)
---
# _inconsistency_: rust startswith allows a list, not just tuple
# https://github.com/facebookexperimental/starlark-rust/issues/23
# '123'.startswith(['3']) ## (got.*want|expected string|type of parameter.*doesn't match)
---
assert_('abc'.endswith(('c', 'C')))
assert_('ABC'.endswith(('c', 'C')))
assert_(not 'ABC'.endswith(('b', 'B')))
---
'123'.endswith((1, 2)) ### (got int, for element 0|type of parameter.*doesn't match)
---
# _inconsistency_: rust endswith allows a lists, not just tuple
# https://github.com/facebookexperimental/starlark-rust/issues/23
# '123'.endswith(['3']) ## (got.*want|mismatch)
---
# _inconsistency_: rust startswith/endswith accept a single argument only
# start/end
# assert_('abc'.startswith('bc', 1))
# assert_(not 'abc'.startswith('b', 999))
# assert_('abc'.endswith('ab', None, -1))
# assert_(not 'abc'.endswith('b', None, -999))

# str.replace
assert_eq("banana".replace("a", "o", 1), "bonana")
assert_eq("banana".replace("a", "o"), "bonono")

# str.{,r}find
assert_eq("foofoo".find("oo"), 1)
assert_eq("foofoo".find("ox"), -1)
assert_eq("foofoo".find("oo", 2), 4)
assert_eq("foofoo".rfind("oo"), 4)
assert_eq("foofoo".rfind("ox"), -1)
assert_eq("foofoo".rfind("oo", 1, 4), 1)
assert_eq("foofoo".find(""), 0)
assert_eq("foofoo".rfind(""), 6)

# str.{,r}partition
assert_eq("foo/bar/wiz".partition("/"), ("foo", "/", "bar/wiz"))
assert_eq("foo/bar/wiz".rpartition("/"), ("foo/bar", "/", "wiz"))
assert_eq("foo/bar/wiz".partition("."), ("foo/bar/wiz", "", ""))
assert_eq("foo/bar/wiz".rpartition("."), ("", "", "foo/bar/wiz"))
---
"foo/bar/wiz".partition("") ### empty separator
---
"foo/bar/wiz".rpartition("") ### empty separator
---

assert_eq('?'.join(["foo", "a/b/c.go".rpartition("/")[0]]), 'foo?a/b')

# str.is{alpha,...}
def test_predicates():
  predicates = ["alnum", "alpha", "digit", "lower", "space", "title", "upper"]
  table = {
      "Hello, World!": "title",
      "hello, world!": "lower",
      "base64": "alnum lower",
      "HAL-9000": "upper",
      "Catch-22": "title",
      "": "",
      "\n\t\r": "space",
      "abc": "alnum alpha lower",
      "ABC": "alnum alpha upper",
      "123": "alnum digit",
      # _inconsistency_: rust title() works differently
      # "ǅǈ": "alnum alpha",
      # _inconsistency_: java produces empty list with unicode
      # "ǅ ǈ": "title",
      # "ǆǉ": "alnum alpha lower",
      # "ǄǇ": "alnum alpha upper",
  }
  for str, want in table.items():
    got = ' '.join([name for name in predicates if getattr(str, "is"+name)()])
    if got != want:
      fail("%r matched [%s], want [%s]" % (str, got, want))

test_predicates()

# Strings are not iterable.
# ok
assert_eq(len("abc"), 3)                       # len
assert_("a" in "abc")                      # str in str
assert_eq("abc"[1], "b")                       # indexing
# not ok
def args(*args): return args

# varargs
args(*"abc") ### (must be iterable, not string|not iterable|must be an iterable|operation.*not supported)
---
# list(str)
list("abc") ### (got string, want iterable|not iterable|not a collection|operation.*not supported)
---
# tuple(str)
tuple("abc") ### (got string, want iterable|not iterable|not a collection|operation.*not supported)
---
# enumerate
enumerate("ab") ### (got string, want iterable|not iterable|expected value of type 'sequence'|operation.*not supported)
---
# sorted
sorted("abc") ### (got string, want iterable|not iterable|not a collection|operation.*not supported)
---
# list.extend
[].extend("bc") ### (got string, want iterable|not iterable|expected value of type 'sequence'|operation.*not supported)
---
# string.join
",".join("abc") ### (got string, want iterable|not iterable|expected value of type 'sequence'|operation.*not supported)
---
# dict
dict(["ab"]) ### (not iterable .*string|non-pair element|cannot convert|operation.*not supported)
---
def for_string():
  for x in "abc":
    pass

# The Java implementation does not correctly reject the following cases:
# (See Google Issue b/34385336)
for_string() ### (not iterable|operation.*not supported)
---
# comprehension
[x for x in "abc"] ### (not iterable|operation.*not supported)
---
# all
all("abc") ### (got string, want iterable|not iterable|operation.*not supported)
---
# any
any("abc") ### (got string, want iterable|not iterable|operation.*not supported)
---
# reversed
reversed("abc") ### (got.*want|not iterable|operation.*not supported)
---
# zip
zip("ab" , "cd") ### (not iterable: string|not iterable|operation.*not supported)
---

# str.join
assert_eq(','.join([]), '')
assert_eq(','.join(["a"]), 'a')
assert_eq(','.join(["a", "b"]), 'a,b')
assert_eq(','.join(["a", "b", "c"]), 'a,b,c')
assert_eq(','.join(("a", "b", "c")), 'a,b,c')
assert_eq(''.join(("a", "b", "c")), 'abc')
---
''.join(None) ### (got NoneType, want iterable|not iterable|parameter 'elements' cannot be None|operation.*not supported)
---
''.join(["one", 2]) ### (join: in list, want string, got int|expected string|must be a string|type of parameter.*doesn't match)
---

# _inconsistency_: string.capitalize works differently in rust
# str.capitalize
# assert_eq("hElLo, WoRlD!".capitalize(), "Hello, world!")
# assert_eq("por qué".capitalize(), "Por qué")
# assert_eq("¿Por qué?".capitalize(), "¿por qué?")

# str.lower
assert_eq("hElLo, WoRlD!".lower(), "hello, world!")
assert_eq("por qué".lower(), "por qué")
assert_eq("¿Por qué?".lower(), "¿por qué?")
assert_eq("ǇUBOVIĆ".lower(), "ǉubović")
assert_("ǆenan ǉubović".islower())

# str.upper
assert_eq("hElLo, WoRlD!".upper(), "HELLO, WORLD!")
assert_eq("por qué".upper(), "POR QUÉ")
assert_eq("¿Por qué?".upper(), "¿POR QUÉ?")
assert_eq("ǉubović".upper(), "ǇUBOVIĆ")
assert_("ǄENAN ǇUBOVIĆ".isupper())

# str.title
assert_eq("hElLo, WoRlD!".title(), "Hello, World!")
assert_eq("por qué".title(), "Por Qué")
assert_eq("¿Por qué?".title(), "¿Por Qué?")
# _inconsistency_: rust title() treats first two unicode chars as single letter
# assert_eq("ǉubović".title(), "ǈubović")
# assert_("ǅenan ǈubović".istitle())
# assert_(not "Ǆenan Ǉubović".istitle())

---
# method spell check
"".starts_with() ### (no .starts_with field.*did you mean .startswith|not supported|no field or method)
---
"".StartsWith() ### (no .StartsWith field.*did you mean .startswith|not supported|no field or method)
---
"".fin() ### (no .fin field.*.did you mean .find|not supported|no field or method)
