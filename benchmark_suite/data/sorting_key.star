def random(seed=35):
  return (seed * 125) % 2796203

def k1(x):
  return x

def k2(x):
  return x * x

def k3(x):
  return x * 2


def benchmark(N):
  sorted([i for i in range(N, -1, -1)], key=k1)
  sorted([i for i in range(N, -1, -1)], key=k1, reverse=True)
  sorted([i for i in range(-N // 100, N // 100)] * 100, key=k2)

  sorted([str(i) for i in range(N // 2)], key=k3)

  l = [random()]
  for _ in range(N // 2):
    l.append(random(l[-1]))
  sorted([str(i) for i in l], key=len)

  return


benchmark(1000000)
