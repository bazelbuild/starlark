def benchmark(N):
  s = " ".join([str(i) for i in range(N)])
  for i in range(N):
    s.find(str(i))
    s.rfind(str(i))


benchmark(50000)
