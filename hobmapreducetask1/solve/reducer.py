#!/usr/bin/env python3

import sys

current_key = None
word_sum = 0

for line in sys.stdin:
    try:
        key, value = line.strip().split("\t", 1)
        value = int(value)
    except ValueError as e:
        continue

    if current_key != key:
        if current_key:
            print("{}\t{}".format(current_key, word_sum))

        word_sum = 0
        current_key = key
    word_sum += value

if current_key:
    print("{}\t{}".format(current_key, word_sum))
