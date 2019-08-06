def benchmark(N):
  a = [str(i) for i in range(N)]

  for i in range(N):
    a.remove(str(N - i - 1))


benchmark(30000)
