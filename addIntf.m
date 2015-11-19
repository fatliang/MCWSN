function network = addIntf(network,Rc,Nintf)
num_CH = length(network);
for i = 1:num_CH
    for j = 1:num_CH
        if i ~= j && cal_dist(network(i),network(j)) < Nintf*Rc
            network(i).intf = [network(i).intf, j];
        end
    end
end