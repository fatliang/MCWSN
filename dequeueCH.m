function [network,j] = dequeueCH(network,i)
j = network(i).queue(1);
network(i).queue(1) = [];