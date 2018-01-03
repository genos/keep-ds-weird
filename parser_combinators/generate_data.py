#!/usr/bin/env python3
# coding: utf-8
"""Generate fake weather data for parser combinbator examples"""

from datetime import date, time, timedelta
from random import choice, normalvariate, random, randrange, seed


SENSOR_IDS = "ABC"
START_DATE = date(2018, 1, 1)
WIND_DIRECTIONS = "NSEW"
SPACES = [' ', '\t', ' \t', '\t ', '\t\t', '   ']


class Datum:
    """Fake weather datum for parser combinator examples"""

    __slots__ = [
        'sensor_id',
        'date',
        'time',
        'temperature',
        'humidity',
        'wind_direction',
        'wind_speed',
    ]

    def __init__(self, date):
        self.sensor_id = choice(SENSOR_IDS)
        self.date = date
        self.time = None
        if choice([True, False]):
            self.time = time(
                hour=randrange(0, 24),
                minute=randrange(0, 60),
                second=randrange(0, 60))
        self.temperature = normalvariate(75, 10)
        self.humidity = random()
        self.wind_direction = None
        self.wind_speed = None
        if choice([True, False]):
            self.wind_direction = choice(WIND_DIRECTIONS)
            self.wind_speed = randrange(15)

    def __str__(self):
        return ''.join([
            self.sensor_id,
            choice(SPACES),
            self.date.isoformat(),
            choice(SPACES),
            '' if self.time is None else self.time.isoformat(),
            choice(SPACES),
            "{:2.1f}".format(self.temperature),
            choice(SPACES),
            "{:.0%}".format(self.humidity),
            '' if self.wind_direction is None or self.wind_speed is None
               else ''.join([
                   choice(SPACES),
                   self.wind_direction,
                   choice(SPACES),
                   "{:d}".format(self.wind_speed)
               ])
        ])


if __name__ == '__main__':
    seed(1729)
    for i in range(10):
        print(Datum(date=START_DATE + timedelta(i)))
