def random(seed=35):
  return (seed * 125) % 2796203

  
def benchmark(N):
  sorted([0 for _ in range(N)])
  sorted([i for i in range(N)])
  sorted([i for i in range(N, -1, -1)])

  l = [random()]
  for _ in range(N-1):
    l.append(random(l[-1]))
  sorted(l)

  return


benchmark(1000000)
