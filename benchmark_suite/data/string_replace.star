def benchmark(N):
  s = "".join(['a' for _ in range(N)])
  for i in range(N):
    s.replace(s[i:], s[i:])


benchmark(4000)
