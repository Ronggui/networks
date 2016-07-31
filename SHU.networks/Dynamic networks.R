## 动态网可视化及分析
## 上海大学延长校区, 2016/7/31
## 黄荣贵， 复旦大学

library(network)
library(ergm)
library(networkDynamic)
library(ndtv)

## demo: construction of network
## read in  edgelist data
edges = read.csv("ex1_edgelist.csv")
## read in vertex attribute data
nodes = read.csv("ex1_vertex.attributes.csv", stringsAsFactors = FALSE)
## construction of a network
dn <- network.edgelist(edges, network.initialize(5),
                       ignore.eval=FALSE)
## set vertex attribute
dn %v% "gender" = nodes$gender
## plot
plot(dn)


## full example, only R commands (but not the network objects) are provided
linmap = function(x, max_value, min_value) {
  a = min(x)
  b = max(x)
  ans = (max_value - min_value) * (x - a) / (b - a) + min_value
  return(ans)
}

setwd("~/Dynamic networks")
atnet12 = igraph::read_graph("atnet12B.graphml", "graphml")
atnet13 = igraph::read_graph("atnet13B.graphml", "graphml")
atnet14 = igraph::read_graph("atnet14B.graphml", "graphml")

net12 = intergraph::asNetwork(atnet12)
net13 = intergraph::asNetwork(atnet13)
net14 = intergraph::asNetwork(atnet14)

## use net12 to show the plotting of static network
plot(net12)

# shape is vertex attribute in the net12 object
# rule of color assignment: square-red, diamond-blue, circle-green
def_col = function(net){
  shape = get.vertex.attribute(net, "shape")
  ans = car::recode(shape, "'square'='red'; 'diamond'='blue'; 'circle'='green'", FALSE)
  ans
}

set.vertex.attribute(net12, "color", def_col(net12))
set.vertex.attribute(net13, "color", def_col(net13))
set.vertex.attribute(net14, "color", def_col(net14))

plot(net12, vertex.col='color') 

col2rgb('grey', TRUE)
rgb(190, 190, 190, 255, maxColorValue = 255) ## 非透明
rgb(190, 190, 190, 50, maxColorValue = 255) ## 透明

set.edge.attribute(net12, "color", "#BEBEBEFF")
plot(net12, vertex.col="color", edge.col="color")

vcol = get.vertex.attribute(net12, "color")

def_edge_col = function(x, y){
  if (x == y) {
    #return("#BEBEBE32")
    return("#BEBEBE64")
  } else {
    #return(rgb(0, 0, 1, 0.19))
    return(do.call(rgb, as.list(unlist(c(col2rgb(y), 100, 'color', 255)))))
  }
}

edge_col = outer(vcol, vcol, Vectorize(def_edge_col))
net12 %e% "color" = edge_col
plot(net12, vertex.col="color", edge.col="color")

set.vertex.attribute(net12, "size", linmap(sna::degree(net12), 4, 1))
plot(net12, vertex.col="color", edge.col="color", vertex.cex="size")


set.seed(100)
init.coords = matrix(rnorm(network.size(net12)*2), ncol=2)
plot(net12, vertex.col="color", edge.col="color", vertex.cex="size", layout.par = list(seed.coord = init.coords))

ew = get.edge.attribute(net12, "weight")
set.edge.attribute(net12, "width", linmap(log(ew), 20, 0.5))
plot(net12, vertex.col="color", edge.col="color", 
     layout.par = list(seed.coord = init.coords),
     vertex.cex="size", edge.lwd="width")

set.vertex.attribute(net12, "color", def_col(net12))
set.vertex.attribute(net13, "color", def_col(net13))
set.vertex.attribute(net14, "color", def_col(net14))

vcol <- net12 %v% "color"
edge_col = outer(vcol, vcol, Vectorize(def_edge_col))
net12 %e% "color" = edge_col

vcol <- net13 %v% "color"
edge_col = outer(vcol, vcol, Vectorize(def_edge_col))
net13 %e% "color" = edge_col

vcol <- net14 %v% "color"
edge_col = outer(vcol, vcol, Vectorize(def_edge_col))
net14 %e% "color" = edge_col

set.vertex.attribute(net12, "size", linmap(sna::degree(net12), 4, 1))
set.vertex.attribute(net13, "size", linmap(sna::degree(net13), 4, 1))
set.vertex.attribute(net14, "size", linmap(sna::degree(net14), 4, 1))

#### manually combine three static networks
#### this can be done through collapsing a dynamic network object (see below)
## network to adjacency matrix
adj12 = net12[,]
adj13 = net13[,]
adj14 = net14[,]
## vertex names
nodes = unique(c(colnames(adj12), colnames(adj13), colnames(adj14)))
nodes = make.names(nodes) ## make it valid for colnames/rownames
## create an empty matrix to represent the combined network
adj3 = matrix(0, length(nodes), length(nodes))
colnames(adj3) <- rownames(adj3) <- nodes
## add the first network to the combined network
ind12 = which(adj12 > 0, arr.ind = TRUE)
nodes12 = make.names( net12 %v% "vertex.names")
for (i in 1:nrow(ind12)) {
  s = ind12[i, 1]
  d = ind12[i, 2]
  adj3[nodes12[s], nodes12[d]] <- adj12[s, d] + 1 
  ## make use of colname/rowname indexing
}
## add the second network to the combined network
ind13 = which(adj13 > 0, arr.ind = TRUE)
nodes13 = make.names( net13 %v% "vertex.names")
for (i in 1:nrow(ind13)) {
  s = ind13[i, 1]
  d = ind13[i, 2]
  adj3[nodes13[s], nodes13[d]] <- adj13[s, d] + 1
}
## add the third network to the combined network
ind14 = which(adj14 > 0, arr.ind = TRUE)
nodes14 = make.names( net14 %v% "vertex.names")
for (i in 1:nrow(ind14)) {
  s = ind14[i, 1]
  d = ind14[i, 2]
  adj3[nodes14[s], nodes14[d]] <- adj13[s, d] + 1
}
## create network from adjacency matrix
net3 = network(adj3)
set.edge.attribute(net3, "color", "#BEBEBE32")
## calculate the layout
set.seed(100)
init.coords = matrix(rnorm(network.size(net3)*2), ncol=2)
lo = network.layout.fruchtermanreingold(net3, layout.par = list(seed.coord = init.coords))
## plotting with fixed layout
plot(net3, edge.col="color", coord=lo)

## get layout for static networks
rownames(lo) <- (net3 %v% "vertex.names")
lo12 = lo[make.names(net12 %v% "vertex.names"), ]
lo13 = lo[make.names(net13 %v% "vertex.names"), ]
lo14 = lo[make.names(net14 %v% "vertex.names"), ]
## plotting with same layout
plot(net12, vertex.col="color", edge.col="color", coord=lo12, vertex.cex="size")
plot(net13, vertex.col="color", edge.col="color", coord=lo13, vertex.cex="size")
plot(net14, vertex.col="color", edge.col="color", coord=lo14, vertex.cex="size")

## descriptive statistics of the three networks
prop.table(table(net12 %v% "color"))
prop.table(table(net13 %v% "color"))
prop.table(table(net14 %v% "color"))

summary(net12~nodemix("color"))
sum(summary(net12~nodemix("color")))
prop.table(summary(net12~nodemix("color")))
summary(net13~nodemix("color"))
prop.table(summary(net13~nodemix("color")))
summary(net14~nodemix("color"))
prop.table(summary(net14~nodemix("color")))

## delete unused vertex attributes to speed the construction of networkDynamic
## should not remove the na attribute
delete.vertex.attribute(net12, "id")
delete.vertex.attribute(net12, "shape")
delete.vertex.attribute(net13, "id")
delete.vertex.attribute(net13, "shape")
delete.vertex.attribute(net14, "id")
delete.vertex.attribute(net14, "shape")
delete.edge.attribute(net12, "weight") 
delete.edge.attribute(net13, "weight")
delete.edge.attribute(net14, "weight")


n3 = networkDynamic(network.list=list(net12, net13, net14), 
                    vertex.pid="vertex.names", create.TEAs=TRUE)
save(n3, file="dynamic networks 2012-2014.rdata")

render.d3movie(n3, filename="dynet20122014.html", 
               edge.col="color", vertex.col="color")

saveVideo(render.animation(n3, edge.col="color", vertex.col="color",
                           displaylabels = FALSE, 
                           render.par = list(tween.frames = 30)), 
          video.name="dynammic_network.mp4", 
          ffmpeg='/Users/rghuang/Downloads/ffmpeg/ffmpeg')

## ffmpeg can be download from https://ffmpeg.org/

network.collapse(n3, 0, 1) ## same as net12
network.collapse(n3, 1, 2) ## same as net13
network.collapse(n3, 2, 3) ## same as net14
net3b = network.collapse(n3, 0, 3) 
## same as net3, can be used to calc the overall layout
