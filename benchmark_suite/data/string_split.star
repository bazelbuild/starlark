def benchmark(N, K):
  a = "-".join(['a' for _ in range(N)])
  for i in range(K):
    a.split('-', N // 2 - i)
    a.rsplit('-', N // 2 - i)


benchmark(100000, 1000)
