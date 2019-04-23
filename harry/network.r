library('igraph')

#find the mean distance of the postswith relation
#of the nth thousand sequence
distance <- function(n){
  path <- paste("harry/maps/postswith/", n, ".csv", sep="")
  network <- read.csv(path)
  
  graph <- graph_from_data_frame(network, directed = F)
  
  return(mean_distance(graph))
}

network <- read.csv("harry/maps/postswith/301.csv")

graph <- graph_from_data_frame(network, directed = F)

small_threshold <- 700
small_vertices_count <- 0
for(vertex in V(graph)){
    if(degree(graph, vertex) < small_threshold){
        small_vertices_count <- small_vertices_count+1  
    }
}

small_vertices= vector("list", length= small_vertices_count)
i <- 1
for(vertex in V(graph)){
  if(degree(graph, vertex) < small_threshold){
    small_vertices[i] <- vertex
    i <- i+1
  }
}

small_graph <- delete_vertices(graph, small_vertices)

length(V(small_graph))
plot(small_graph, vertex.label=NA, edges.curved= F)

known <- c(1:10, 75:83, 150:153, 225:234, 301)
plot(known, lapply(known, distance))

