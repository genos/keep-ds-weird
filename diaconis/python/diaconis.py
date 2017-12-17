#!/usr/bin/env python
# coding: utf-8

from collections import Counter
from itertools import permutations
from math import factorial
import numpy as np


def rho(p):
    return np.matrix([np.eye(len(p), dtype=int)[:, i] for i in p])


def fourier_transform(ps):
    c = Counter(tuple(p) for p in ps)
    return sum(rho(p) * c[p] for p in c)


def fourier_transform_2(ps):
    return sum(map(rho, ps))


if __name__ == '__main__':
    N = 10
    S_N = np.array(list(permutations(range(N))))
    ps = S_N[np.random.randint(factorial(N), size=10000)]
    fhat = fourier_transform(ps)
    print("Permutations:\n{0}\n\nFourier Transform:\n{1}".format(ps, fhat))
