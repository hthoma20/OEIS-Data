#!/bin/env python
import pdb
from itertools import combinations
from string import punctuation
import numpy as np
import re
import sqlite3

conn = sqlite3.connect('oeis_parsed.sqlite3')
c = conn.cursor()
columns = ['comments', 'formulas', 'maple_programs',
           'mathematica_programs', 'other_programs',
           'author', 'extensions_and_errors']


# split on '- _username_, Mmm dd yyyy\n'
commentend = re.compile(r'_([A-Za-z ]+)_, \w{3} \d{1,2} \d{4}\n')

people = dict()
for column in columns:
    c.execute('''select oeis_id, %s
    from oeis_entries limit 300000''' % column)
    for oid, comments in c:
        if comments is None or len(comments)==0:
            continue
        for commentor in commentend.findall(comments):
            if len(commentor)>40:
                pdb.set_trace()
            if commentor not in people:
                people[commentor] = set()
            people[commentor].add(oid)

with open('commentor_graph.csv', 'w') as f:
    for a, b in combinations(people, 2):
        oids = people[a] & people[b]
        if people[a] & people[b]:
            f.write(a + chr(127) + b + chr(127) +
                    '_'.join(str(i) for i in oids) + '\n')

