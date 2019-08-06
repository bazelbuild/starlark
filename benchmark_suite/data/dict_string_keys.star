def benchmark(N):
  d = {}
  for i in range(N // 2):
    d[str(i * 1000)] = False
    d[str((i + N // 2) * 1000)] = False

  for i in range(N - 1, -1, -1):
    d.get(str(i * 1000))
    d.update([(str(i * 1000), True)])

  for i in range(N):
    d.pop(str(i * 1000))


benchmark(1000000)
