function res = cal_dist_pos(CH,sita,r)
%calculate the distance of a CH to a fix position
pos = [];
for i = 1:length(CH)
  pos = [pos;CH(i).pos(1),CH(i).pos(2)];
end
[x1,y1] = pol2cart(pos(:,1),pos(:,2));
[x2,y2] = pol2cart(sita,r);
res = sqrt((x1-x2).^2+(y1-y2).^2);