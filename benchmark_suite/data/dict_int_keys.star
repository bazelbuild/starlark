def benchmark(N):
  d = {}
  for i in range(N // 2):
    d[i * 1000] = False
    d[(i + N // 2) * 1000] = False

  for i in range(N - 1, -1, -1):
    d.get(i * 1000)
    d.update([(i * 1000, True)])

  for i in range(N):
    d.pop(i * 1000)


benchmark(1000000)
