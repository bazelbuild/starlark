def benchmark(N):
  a = [i for i in range(N)]

  for i in range(N):
    a.remove(N - i - 1)


benchmark(30000)
