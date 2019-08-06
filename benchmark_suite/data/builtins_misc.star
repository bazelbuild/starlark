def benchmark(N):
  any([False for _ in range(N)])
  all([True for _ in range(N)])

  bool([None for _ in range(N)])
  list(tuple([None for _ in range(N)]))
  enumerate([None for _ in range(N)])

  max([True for _ in range(N)])
  min([True for _ in range(N)])

  list(range(N))
  reversed(range(N))
  repr([None for _ in range(N)])
  str([None for _ in range(N)])
  zip(range(N), range(N))
  _ = [type(None) for _ in range(N)]
  _ = [hasattr("", str(i)) for i in range(N)]


benchmark(1000000)
