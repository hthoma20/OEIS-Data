library('igraph')

#find the mean distance of the postswith relation
#of the nth thousand sequence
distance <- function(n, dir_path){
  path <- paste("harry/", dir_path, "/", n, ".csv", sep="")
  network <- try(read.csv(path), silent= T)
  
  if(class(network) == "try-error"){
    return(0)
  }
  
  graph <- graph_from_data_frame(network, directed = F)
  
  return(mean_distance(graph))
}

network <- read.csv("harry/all_graph.csv")

graph <- graph_from_data_frame(network, directed = F)

small_threshold <- 500
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



#all values -- these are known now
known_comments <- 1:300

#get the mean distance
means <- lapply(known_comments, distance, dir_path= "maps_comments")

plot(known_comments, means)

#the values I know
known_all <- 1:300 #c(1:15, 75:86, 150:157, 225:237, 301)
all_means <- lapply(known_all, distance, dir_path= "maps_all")
points(known_all, all_means, "p", col="red")


for(i in 1:length(V(user_network))){
     max= max(sapply(shortest_paths(user_network, 1)$vpath, length))
     if(max > maxmax){
         print(i)
         maxmax= max
     }
}
