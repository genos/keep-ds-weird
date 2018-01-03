#!/usr/bin/env python
# coding: utf-8

import numpy as np
import timeit


def naive(X):
    result = []
    for (i, x) in enumerate(X):
        min_j, min_d = -1, np.inf
        for (j, y) in enumerate(X):
            if i != j:
                d = sum((y[k] - x[k])**2 for k in range(len(x)))
                if d < min_d:
                    min_j, min_d = j, d
        result.append(min_j)
    return result


def no_loops(X):
    # https://speakerdeck.com/jakevdp/losing-your-loops-fast-numerical-computing-with-numpy-pycon-2015
    m, n = X.shape
    d = X.reshape(m, 1, n) - X
    D = (d**2).sum(axis=2)
    i = np.arange(m)
    D[i, i] = np.inf
    result = np.argmin(D, axis=1)
    return result


def check_equality(X):
    naive_answer = naive(X)
    no_loops_answer = no_loops(X)
    print("Does the no loops answer match the naive answer?\n\t{}".format(
        "Yes" if np.all(no_loops_answer == naive_answer) else "No"))


def timings(X, repeat=3, number=100):
    naive_timing = timeit.repeat(
        'naive(X)', repeat=repeat, number=number, globals=globals())
    no_loops_timing = timeit.repeat(
        'no_loops(X)', repeat=repeat, number=number, globals=globals())
    print("Naive timing:\n\t{}".format(naive_timing))
    print("No loops timing:\n\t{}".format(no_loops_timing))
    print("min(naive) / max(no_loops_timing):\n\t{}".format(
        np.min(naive_timing) / np.max(no_loops_timing)))


if __name__ == '__main__':
    np.random.seed(1729)
    X = np.random.random((100, 3))
    check_equality(X)
    timings(X)
