#!/bin/env python
import numpy as np
import re
import sys
import sqlite3
import nltk

conn = sqlite3.connect('oeis_parsed.sqlite3')
c = conn.cursor()
c.execute('''select oeis_id, comments
from oeis_entries limit 300000''')

# split on '- _username_, Mmm dd yyyy\n'
commentend = re.compile(r'(?:-|\.\.\.\.) _([^_]+)_, \w{3} \d{1,2} \d{4}\n')
al = re.compile(r'[A-Za-z]{2,}')

ind = []
dists = []
words = set()
totaldist = nltk.FreqDist()
for oid, comments in c:
    if oid%1000 == 0:
        print('oid = %d' % oid)
    ind.append(oid)
    if comments is None or len(comments)==0:
        continue

    tokens = nltk.word_tokenize(commentend.sub('\n', comments))
    tokens = [t.lower() for t in tokens
              if al.match(t) is not None]
    dist = nltk.FreqDist(tokens)
    dists.append(dist)
    words |= dist.keys()
    totaldist += dist

# count how many sequences has word
ps = nltk.stem.PorterStemmer()
hasword = {}
for word in words:
    hasword[word] = 0
for dist in dists:
    for word in dist.keys():
        hasword[word] += 1

# remove common words
hasworddist = sorted(hasword.items(), reverse=True,
                     key = lambda item: item[1])
brown = nltk.FreqDist(ps.stem(w.lower())
                      for w in nltk.corpus.brown.words())
commonwords = brown.most_common(100)
commonwords = set(pair[0] for pair in commonwords)

# compare OEIS frequency against brown
brownthe = brown['the']
oeisthe = totaldist['the']
wordl = sorted(words)
wordratio = []
for word in wordl:
    if brown[ps.stem(word)]==0:
        wordratio.append(0)
        continue
    wordratio.append(totaldist[word]/oeisthe /
                     (brown[ps.stem(word)]/brownthe))
ratiosort = np.argsort(wordratio)
with open('sorted_freq_ratio.txt','w') as f:
    for ord in ratiosort:
        f.write('%s,%d,%d,%f\n' % (wordl[ord],
                                   totaldist[wordl[ord]],
                                   brown[ps.stem(wordl[ord])],
                                   wordratio[ord]))

with open('word_list.txt', 'w') as f:
    f.write('\n'.join(wordl))
with open('freqdist.csv', 'w') as f:
    for row, dist in enumerate(dists):
        f.write(str(ind[row]))
        for word in wordl:
            f.write(',')
            f.write(str(dist[word]))
        f.write('\n')
# print(words)
