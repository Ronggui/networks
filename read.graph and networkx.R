## read pajek net file exported by networkx
library(igraph)
net <- read.graph("envir-ngo.paj.net", format="pajek")
net= read.graph("e:/envir-ngo.attedNet3M.paj.net", format="pajek")
# remove self-loops
net <- simplify(net)
## remove unwanted vertex attributes
net = remove.vertex.attribute(net, "shape")
net = remove.vertex.attribute(net, "x")
net = remove.vertex.attribute(net, "y")
plot(net, vertex.label=NA, vertex.size=8)
