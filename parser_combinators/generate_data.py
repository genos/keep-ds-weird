#!/usr/bin/env python3
# coding: utf-8
"""Generate fake weather data for parser combinbator examples"""

import datetime
import random


SENSOR_IDS = "ABC"
START_DATE = datetime.date(2018, 1, 1)
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
        self.sensor_id = random.choice(SENSOR_IDS)
        self.date = date
        self.time = None
        if random.choice([True, False]):
            self.time = datetime.time(
                hour=random.randrange(0, 24),
                minute=random.randrange(0, 60),
                second=random.randrange(0, 60))
        self.temperature = random.normalvariate(75, 10)
        self.humidity = random.random()
        self.wind_direction = None
        self.wind_speed = None
        if random.choice([True, False]):
            self.wind_direction = random.choice(WIND_DIRECTIONS)
            self.wind_speed = random.randrange(15)

    def __str__(self):
        return ''.join([
            self.sensor_id,
            random.choice(SPACES),
            self.date.isoformat(),
            random.choice(SPACES),
            '' if self.time is None else self.time.isoformat(),
            random.choice(SPACES),
            "{:2.1f}".format(self.temperature),
            random.choice(SPACES),
            "{:.0%}".format(self.humidity),
            '' if self.wind_direction is None or self.wind_speed is None
               else ''.join([
                   random.choice(SPACES),
                   self.wind_direction,
                   random.choice(SPACES),
                   "{:d}".format(self.wind_speed)
               ])
        ])


if __name__ == '__main__':
    random.seed(1729)
    for i in range(10):
        print(Datum(date=START_DATE + datetime.timedelta(i)))
