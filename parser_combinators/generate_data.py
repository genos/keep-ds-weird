#!/usr/bin/env python3
# coding: utf-8
"""Generate fake weather data for parser combinbator examples"""

import datetime as dt
import random as r


def space():
    """A random amount of whitespace (tabs and spaces)"""
    return ''.join([r.choice(' \t') for _ in range(r.randrange(1, 4))])


def entry(date):
    """Fake weather entry for parser combinator examples"""
    sensor_id = r.choice("ABC")
    time = None
    if r.choice([True, False]):
        time = dt.time(
            r.randrange(0, 24), r.randrange(0, 60), r.randrange(0, 60))
    temperature = r.normalvariate(75, 10)
    humidity = r.random()
    direction = None
    speed = None
    if r.choice([True, False]):
        direction = r.choice("NSEW")
        speed = r.randrange(15)
    return ''.join([
        sensor_id,
        space(), date.isoformat(),
        space(), '' if time is None else time.isoformat(),
        space(), "{:2.1f}".format(temperature),
        space(), "{:.0%}".format(humidity),
        '' if direction is None or speed is None
        else ''.join([space(), direction, space(), "{:d}".format(speed)])
    ])


if __name__ == '__main__':
    r.seed(1729)
    for i in range(10):
        print(entry(date=dt.date(2018, 1, 1) + dt.timedelta(i)))
