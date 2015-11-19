function drawNetwork(network,K,Rt)
num_CH = length(network);
figure();
%plot CCH
plot(0,0,'o');
hold on;
%plot RCH
for i = 1:K
  [x y] = pol2cart(2*pi/K*(i-1)+2*pi/K/2,Rt);
  plot(x,y,'o');
end

for i = 1:num_CH
    pos = network(i).pos;
    [x,y] = pol2cart(pos(1),pos(2));
    plot(x,y,'.');
    if network(i).level ~= 1
      if  network(i).next_hop == 0
        disp('error');
      end
      pos_next = network(network(i).next_hop).pos;
    elseif network(i).dest == 0
      pos_next = [0,0];
    else
      pos_next = [2*pi/K*(network(i).dest-1)+2*pi/K/2,Rt];
    end
    [x_next,y_next] = pol2cart(pos_next(1),pos_next(2));
    quiver(x,y,x_next-x,y_next-y);
end


