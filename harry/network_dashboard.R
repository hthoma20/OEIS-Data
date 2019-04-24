#This file is meant to be sources by a shiny app in order that the app can
#use the network data.
# This file will create the following variables for use:
# 
# user_network -- an igraph object represetning the entire user network of the OEIS
#
# user_subnetwork -- an igraph object representing a small subset of the user network
#                    for viewing purposes
#
# mean_distances -- a dataframe with two columns - 'n' and 'mean_distance'
#                   where 'mean_distance' is the mean distance of the network
#                   created by the nth thousand sequences
#
# mean_distance_fit -- a linear model to fit the mean_distances data frame


library('igraph')

#find the mean distance of the postswith relation
#of the nth thousand sequence
distance <- function(n, dir_path){
  path <- paste("../", dir_path, "/", n, ".csv", sep="")
  network <- try(read.csv(path), silent= T)
  
  if(class(network) == "try-error"){
    return(0)
  }
  
  graph <- graph_from_data_frame(network, directed = F)
  
  return(mean_distance(graph))
}

#which sequences to find distances of
thousands_range <- 1:300

#compute the data frame of mean distances
mean_distances <- data.frame(thousands_range,
                             sapply(thousands_range, distance, dir_path= "maps_all"))

colnames(mean_distances) <- c("n", "mean_distance")

#compute the linear fit of the mean distances
mean_distance_fit <- lm(mean_distance ~ n, data= mean_distances)

#create the entire network
user_network <- graph_from_data_frame(read.csv("../all_graph_names.csv"), directed = F)

#create a small subnet
user_subnetwork <- induced_subgraph(user_network, V(user_network)[1:7])
