def benchmark(N):
  a = [i for i in range(N)]

  for _ in range(N):
    a.insert(len(a) // 2, 0)

  for _ in range(2 * N):
    a.pop(len(a) // 2)


benchmark(70000)
