"""Generate fake weather data for parser combinbator examples"""

import datetime as dt
import random


def space():
    """A random amount of whitespace (tabs and spaces)"""
    return "".join([random.choice(" \t") for _ in range(random.randrange(1, 4))])


def entry(date):
    """Fake weather entry for parser combinator examples"""
    sensor_id = random.choice("ABC")
    time = None
    if random.choice([True, False]):
        time = dt.time(
            random.randrange(0, 24), random.randrange(0, 60), random.randrange(0, 60)
        )
    temperature = random.normalvariate(75, 10)
    humidity = random.random()
    direction = None
    speed = None
    if random.choice([True, False]):
        direction = random.choice("NSEW")
        speed = random.randrange(15)
    return "".join(
        [
            sensor_id,
            space(),
            date.isoformat(),
            space(),
            "" if time is None else time.isoformat(),
            space(),
            "{:2.1f}".format(temperature),
            space(),
            "{:.0%}".format(humidity),
            ""
            if direction is None or speed is None
            else "".join([space(), direction, space(), "{:d}".format(speed)]),
        ]
    )


if __name__ == "__main__":
    random.seed(1729)
    for i in range(10):
        print(entry(date=dt.date(2020, 1, 1) + dt.timedelta(i)))
