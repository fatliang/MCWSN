function res = cal_dist(CH1,CH2)
[x1,y1] = pol2cart(CH1.pos(1),CH1.pos(2));
[x2,y2] = pol2cart(CH2.pos(1),CH2.pos(2));
res = sqrt((x1-x2)^2+(y1-y2)^2);