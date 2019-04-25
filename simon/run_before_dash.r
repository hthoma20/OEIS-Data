# Make sure stripped and names are in same folder/working directory
# as the code
# Reading the files and making them nice
library(plyr)
# Stripped is downloaded from the OEIS website
stripped <- read.csv("stripped", header= F, comment.char = '#')
colnames(stripped) <- c("id", 1:109)
# remove the names
only_sequences <- stripped[,-1]
# needs package plyr to run
counts2 <- count(unlist(only_sequences))
# Order it in descending order
counts2.ordered = counts2[order(-counts2[,2]),]
# Save file to locations with the shiny app
# First one is all the NA's which we don't need and thus won't save
saveRDS(counts2.ordered[2:dim(counts2.ordered)[1],], file = "all_counts2")
saveRDS(only_sequences, file = 'sequences')
