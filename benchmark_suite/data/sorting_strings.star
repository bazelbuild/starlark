def random(seed=35):
  return (seed * 125) % 2796203


def benchmark(N):
  sorted(['a' for _ in range(N)])
  sorted([str(i) for i in range(N)])
  sorted([str(i) for i in range(N, -1, -1)])

  l = [random()]
  for _ in range(N-1):
    l.append(random(l[-1]))
  sorted([str(i) for i in l])

  return


benchmark(1000000)
