
#find just the first element in each sequence
one <- stripped$"1"
one <- na.omit(one)

#what are the biggest and smallest numbers that have no start?
i <- -1
while(sum(one == i) > 0) i= i-1
i

i <- 1
while(sum(one == i) > 0) i= i+1
i