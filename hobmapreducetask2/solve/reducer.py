#!/usr/bin/env python3

import sys

current_key = None
warn_sum = 0
error_sum = 0

for line in sys.stdin:
    try:
        date, severity, value = line.strip().split("\t", 2)
        value = int(value)
    except:
        continue

    if current_key != date:
        if current_key:
            print("{}\t{}\t{}".format(current_key, error_sum, warn_sum))

        warn_sum = 0
        error_sum = 0
        current_key = date

    if severity == "ERROR":
        error_sum += value
    else:
        warn_sum += value

if current_key:
    print("{}\t{}\t{}".format(current_key, error_sum, warn_sum))

