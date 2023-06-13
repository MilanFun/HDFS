#!/usr/bin/env python3

import sys
import re

for line in sys.stdin:
    line = line.strip()
    try:
        date = re.search("[0-9]{4}-[0-9]{2}-[0-9]{2}", line).group(0)
        severity = re.search("[A-Z]{4,5}", line).group(0)
    except:
        continue
    if severity == "ERROR" or severity == "WARN":
        print("{}\t{}\t1".format(date, severity))
