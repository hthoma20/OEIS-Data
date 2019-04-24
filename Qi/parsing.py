#!/bin/env python
from string import punctuation
import numpy as np
import re
import sys
import sqlite3
import nltk
from bisect import bisect_left

conn = sqlite3.connect('oeis_parsed.sqlite3')
c = conn.cursor()
c.execute('''select oeis_id, comments
from oeis_entries limit 300000''')

# split on '- _username_, Mmm dd yyyy\n'
commentend = re.compile(r'(?:-|\.\.\.\.) _([^_]+)_, \w{3} \d{1,2} \d{4}\n')
al = re.compile(r'[A-Za-z]{2,}')

# form frequency distributions for each sequence
ind = []
dists = []
words = set()
totaldist = nltk.FreqDist()
st = nltk.stem.lancaster.LancasterStemmer()
for oid, comments in c:
    if oid%1000 == 0:
        print('oid = %d' % oid)
    ind.append(oid)
    if comments is None or len(comments)==0:
        continue

    tokens = nltk.word_tokenize(commentend.sub('\n', comments))
    tokens = [t.lower().strip(punctuation)
              for t in tokens
              if al.match(t) is not None]
    dist = nltk.FreqDist(tokens)
    dists.append(dist)
    words |= dist.keys()
    totaldist += dist

#filter obscure words
words = {w for w in words if totaldist[w]>=10}
brown = nltk.corpus.brown.words()
filteredwords = set(nltk.corpus.stopwords.words('english'))
filteredwords.update(word[0] for word in
                     nltk.FreqDist(brown).most_common(1000))
brown = nltk.FreqDist(st.stem(w.lower()) for w in brown)
wordl = sorted(words.difference(filteredwords))

# compare OEIS frequency against brown
wordratio = []
for word in wordl:
    if brown[st.stem(word)]==0:
        wordratio.append(0)
        continue
    wordratio.append(totaldist[word] / brown[st.stem(word)])
ratiosort = np.argsort(wordratio)
with open('sorted_freq_ratio.txt','w') as f:
    for ord in ratiosort:
        f.write('%s,%d,%d,%f\n' % (wordl[ord],
                                   totaldist[wordl[ord]],
                                   brown[st.stem(wordl[ord])],
                                   wordratio[ord]))

# frequency of each word in each sequence
with open('word_list.txt', 'w') as f:
    f.write('\n'.join(wordl))
with open('freqdist.csv', 'w') as f:
    for seq, dist in enumerate(dists):
        for word, count in dist.items():
            wordnum = bisect_left(wordl, word)
            if wordnum>=len(wordl) or wordl[wordnum]!=word:
                continue
            f.write('%d,%d,%d\n' % (seq, wordnum, count))
