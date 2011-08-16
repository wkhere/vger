class memoize(object):
    "Decorator class memoizing values returned by given function."
    def __init__(self, f):
        self.f = f
        self.reset()

    def reset(self):
        self.cache = {}

    def __call__(self, *args):
        try:
            return self.cache[args]
        except KeyError:
            v = self.f(*args)
            self.cache[args] = v
            return v
        except TypeError:
            # arg is not hashable thus not cachable
            return self.f(*args)

