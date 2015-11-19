function [dest, level] = cal_RCH_level(sita,rou,K,Rc,Rt)
%calculate the RCH destination of the node and the level it belongs to
%w.r.t to the RCH
interval = 2*pi/K;%the positions of RCHs are (interval*(i-1)+interval/2,Rt)
if sita < 0
  sita = sita + 2*pi;
end
dest = floor(sita/interval)+1;
%distance to destination
[x_d,y_d] = pol2cart(interval*(dest-1)+interval/2,Rt);
[x,y] = pol2cart(sita,rou);
dist = sqrt((x-x_d)^2+(y-y_d)^2);
level = ceil(dist/Rc);
    