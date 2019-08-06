def benchmark(N, K):
  s1 = str([i % 10 for i in range(N)])
  s2 = "".join(['a' for _ in range(N)])
  for _ in range(K):
    hash(s1)
    hash(s2)

    
benchmark(1000000, 1000)
