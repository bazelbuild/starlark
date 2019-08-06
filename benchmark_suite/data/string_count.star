def benchmark(N):
  s = "".join([str(i) for i in range(N)])
  for i in range(N):
    s.count(str(i))


benchmark(25000)
