# Make sure stripped and names are in same folder/working directory
# as the code
# Reading the files and making them nice
stripped <- read.csv("stripped", header= F, comment.char = '#')
#names <- read.delim("names", header= F, sep= "\n", quote= "", comment.char = '#')
colnames(stripped) <- c("id", 1:109)
# Can't set rownames, some rows are not unique apperantly
# How often each number occurs for all entries
only_sequences <- stripped[,-1]
counts <- table(unlist(only_sequences)) #-1 cause not the name of each sequence
ordered_all_counts <- counts[order(-counts)]
saveRDS(ordered_all_counts, file = "results/all_counts")
ordered.df <- as.data.frame(ordered_all_counts)
# This will be used to find specific number for dashboard:
counts["5"]

# Nice Histogram:
hist(counts, xlim = c(-20,100), ylim = c(0,500), breaks = 1e6)
rowcount <- rowSums(stripped[, -1] == '1' )
count.1 <- apply(only_sequences, 1, function(x) length(which(x=="1")))

# Count per row
# TODO: make sure the NA's don't give problems
