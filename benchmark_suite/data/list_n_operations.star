def benchmark(N):
  a = []
  for i in range(N // 3):
    a.append(i)
  for i in range(N // 3, 2 * N // 3):
    a += [i]
  for i in range(2 * N // 3, N):
    a.extend([i])
  for i in range(N):
    a.pop()


benchmark(1500000)
