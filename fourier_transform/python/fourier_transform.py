#!/usr/bin/env python
# coding: utf-8

from collections import Counter
import numpy as np


def rho(p):
    return np.matrix([np.eye(len(p), dtype=int)[:, i] for i in p])


def fourier_transform(ps):
    c = Counter(tuple(p) for p in ps)
    return sum(rho(p) * c[p] for p in c)


def fourier_transform_2(ps):
    return sum(map(rho, ps))


if __name__ == "__main__":
    np.random.seed(1729)
    k = 5
    n = 500
    ps = np.repeat([np.arange(k)], n, axis=0)
    for p in ps:
        np.random.shuffle(p)
    fhat = fourier_transform(ps)
    print("Permutations:\n{0}\n\nFourier Transform:\n{1}".format(ps, fhat))
