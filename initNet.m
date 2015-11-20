function network = initNet(network,K,Rt)
%initialize the network, setting the average waiting time and queue
num_CH = length(network);
%the standard waiting time is 1
wait_time = 1;

for i = 1:num_CH
    network(i).wait_time = wait_time;
    network(i).queue = zeros(1,num_CH);
    if network(i).next_hop == 0
        if network(i).dest == 0
            network(i).pos_next = [0,0];
        else
            %the position of RCH should be 2pi/K*(dest-1)+ 2pi/2K
            network(i).pos_next = [2*pi/K*(network(i).dest-1)+2*pi/K/2,Rt];
        end
    else
        network(i).pos_next = network(network(i).next_hop).pos;
    end
end