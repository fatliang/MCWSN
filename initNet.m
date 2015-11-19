function network = initNet(network)
%initialize the network, setting the average waiting time and queue
num_CH = length(network);
%the standard waiting time is 1
wait_time = 1;
for i = 1:num_CH
  network(i).wait_time = wait_time;
  network(i).queue = [i];
end