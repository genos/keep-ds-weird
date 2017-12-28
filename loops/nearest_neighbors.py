#!/usr/bin/env python
# coding: utf-8

import numpy as np
from sklearn.neighbors import NearestNeighbors
import timeit


def naive(X):
    result = []
    for (i, x) in enumerate(X):
        min_j = -1
        min_d = np.inf
        for (j, y) in enumerate(X):
            d = 0
            for k in range(len(x)):
                d += (y[k] - x[k])**2
            if i != j and d < min_d:
                min_j, min_d = j, d
        result.append(min_j)
    return np.array(result)


def no_loops(X):
    # https://speakerdeck.com/jakevdp/losing-your-loops-fast-numerical-computing-with-numpy-pycon-2015
    m, n = X.shape
    diff = X.reshape(m, 1, n) - X
    D = (diff**2).sum(axis=2)
    i = np.arange(m)
    D[i, i] = np.inf
    result = np.argmin(D, axis=1)
    return result


def reference(X):
    _, ns = NearestNeighbors(n_neighbors=2, n_jobs=-1).fit(X).kneighbors(X)
    return ns[:, 1]


def check_equality(X):
    naive_answer = naive(X)
    no_loops_answer = no_loops(X)
    reference_answer = reference(X)
    print(np.all(naive_answer == reference_answer))
    print(np.all(no_loops_answer == reference_answer))


def timings(X):
    print(timeit.timeit('naive(X)', globals=globals()))
    print(timeit.timeit('no_loops(X)', globals=globals()))


if __name__ == '__main__':
    np.random.seed(1729)
    X = np.random.random((5, 3))
    check_equality(X)
    timings(X)
