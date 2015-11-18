function drawNetwork(network)
num_CH = length(network);
figure();
plot(0,0,'o');
hold on;
for i = 1:num_CH
    pos = network(i).pos;
    r = pos(2);
    sita = pos(1);
    x = r*cos(sita);
    y = r*sin(sita);
    plot(x,y,'o');
end