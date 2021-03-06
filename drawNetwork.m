function drawNetwork(network,K,Rt)
num_CH = length(network);
figure();
x_RCCH = [0];
y_RCCH = [0];

%plot CCH
%plot(0,0,'o');
%hold on;
%plot RCH

for i = 1:K
  [x y] = pol2cart(2*pi/K*(i-1)+2*pi/K/2,Rt);
  x_RCCH = [x_RCCH x];
  y_RCCH = [y_RCCH y];
end

plot(x_RCCH,y_RCCH,'ro');
hold on;
x_CH = [];
y_CH = [];
u_CH = [];
v_CH = [];
for i = 1:num_CH
    pos = network(i).pos;
    [x,y] = pol2cart(pos(1),pos(2));
    x_CH = [x_CH x];
    y_CH = [y_CH y];
%     if network(i).level ~= 1
%       if  network(i).next_hop == 0
%         disp('error');
%       end
%       pos_next = network(network(i).next_hop).pos;
%     elseif network(i).dest == 0
%       pos_next = [0,0];
%     else
%       pos_next = [2*pi/K*(network(i).dest-1)+2*pi/K/2,Rt];
%     end
    [x_next,y_next] = pol2cart(network(i).pos_next(1),network(i).pos_next(2));
    u_CH = [u_CH x_next-x];
    v_CH = [v_CH y_next-y];
    
end
hh = plot(x_CH,y_CH,'black.');
hh.MarkerSize = 10;
for i = 1:num_CH
  quiver(x_CH(i),y_CH(i),u_CH(i),v_CH(i),'--blue');
end
%quiver(x_CH,y_CH,u_CH,v_CH);
