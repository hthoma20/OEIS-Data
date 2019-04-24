# Make sure stripped and names are in same folder/working directory
# as the code
# Reading the files and making them nice
library(plyr)
stripped <- read.csv("../stripped", header= F, comment.char = '#')
colnames(stripped) <- c("id", 1:109)
# remove the names
only_sequences <- stripped[,-1]
unlisted <- unlist(only_sequences)
# needs package plyr to run
counts2 <- count(unlist(only_sequences))
counts <- table(unlist(only_sequences), dnn = 'Integer') #-1 cause not the name of each sequence
ordered_all_counts <- counts[order(-counts)]
saveRDS(only_sequences, file = "sequences")
counts2.ordered = counts2[order(-counts2[,2]),]
saveRDS(counts2.ordered[2:dim(counts2.ordered)[1],], file = "all_counts2")
