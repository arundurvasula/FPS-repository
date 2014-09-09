#!/usr/bin/env python
# use like $ csv-to-tsv.py < in.csv > out.tsv
import sys
import csv

commain = csv.reader(sys.stdin, dialect=csv.excel)
tabout= csv.writer(sys.stdout, dialect=csv.excel_tab)
for row in commain:
    tabout.writerow(row)
