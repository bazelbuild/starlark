def benchmark(N, K):
  s = str(['a' for _ in range(N)])
  for i in range(K):
    s = 'a' + s + 'a'


benchmark(500000, 1000)
