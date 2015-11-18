function network = add_route(network,i,j)
%add routing from CH i to CH j
network(i).next_hop = j;
network(j).carry = [network(j).carry, i];