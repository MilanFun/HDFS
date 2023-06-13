#!/usr/bin/env python3

import sys
import re

for line in sys.stdin:
    names = line.strip().split(" ")
    
    # Set names (need unique)
    for name in set(names):
        if len(name) >= 6 and len(name) <= 9:
            if name[0].isupper() and name[1:].islower() and name.isalpha():
                if not name[-1].isalpha() or not name[-2].isalpha():
                    count = 1
                    for i in range(len(name)):
                        if not name[(-1) * i].isalpha():
                            count += 1
                    name = name[:(-1) * count]
                print("{}\t{}".format(name.lower(), 1))
