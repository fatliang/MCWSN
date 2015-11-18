function drawNetwork(network,K,Rt)
num_CH = length(network);
figure();
%plot CCH
plot(0,0,'o');
hold on;
%plot RCH
for i = 1:K
  [x y] = pol2cart(2*pi/K*(i-1),Rt);
  plot(x,y,'o');
end

for i = 1:num_CH
    pos = network(i).pos;
    r = pos(2);
    sita = pos(1);
    x = r*cos(sita);
    y = r*sin(sita);
    plot(x,y,'.');
end