library(data.table) # for fread
library(Matrix)
library(arules)
library(arulesViz)
library(wordspace) # for dist.matrix
library(RColorBrewer)




data <- fread('../freqdist.csv')
names(data) <- c('seq', 'wordnum', 'count')
wordlist <- read.table('../word_list.txt')$V1
data <- data.frame(data, word = factor(data$wordnum, labels = wordlist))
mat2 <- sparseMatrix(j = data$seq+1, i = data$wordnum+1, x = data$count)
freq <- fread('../sorted_freq_ratio.txt')
names(freq) <- c('word', 'oeis', 'brown', 'ratio')

## hierarchial clustering
dis <- as.dist(dist.matrix(mat2), diag=T) # dist.matrix is optimized for sparse matrices
hitre <- hclust(dis, method='average')




# ## association
# mat <- new('ngTMatrix', i=data$wordnum, j=data$seq, 
#            Dim=(c(as.integer(max(data$wordnum)+1), as.integer(max(data$seq)+1))), 
#            Dimnames= list(as.character(wordlist), NULL))
# trans <- as(as(mat, 'ngCMatrix'), 'transactions')
# 
# items <- apriori(trans, parameter = list(minlen=4, support=.01, target="frequent itemsets"))
# inspect(head(sort(items, by="support"), 100))
# 
# rules <- apriori(trans, parameter = list(minlen=2))
# inspect(head(sort(rules, by="lift"), 100))