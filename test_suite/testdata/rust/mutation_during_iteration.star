# Test for disallowing mutation during iteration.
# https://github.com/bazelbuild/starlark/blob/815aed90b552fa70adca4dc18d73082fae83b538/design.md#no-mutation-during-iteration
a = [1, 2, 3]
def fun():
  for x in a:
    a.append(1)

fun()  ### (Cannot mutate an iterable while iterating|cannot append|temporarily immutable)
---
def increment_values(dict):
  for k in dict:
    dict[k] += 1

dict = {"one": 1, "two": 2}
increment_values(dict)   ### (Cannot mutate an iterable while iterating|cannot insert|temporarily immutable)
---
# modifying deep content is allowed
def modify_deep_content():
  list = [[0], [1], [2]]
  for x in list:
    list[x[0]][0] = 2 * x[0]
  return list
assert_eq(modify_deep_content(), [[0], [2], [4]])
