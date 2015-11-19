%network
%parameters
d = 400; %the radius of the whole area
Rc = 30; %the communication range of CH, which is also the distribution interval of CHs
rc = 15; %the communication range of node
beta = 2; %the fading coefficient
gamma = 5; %the transmission threshold, in dB
Nintf = 2; %the CSMA sensing range is Nintf*Rc, remark: it should be higher when beta = 2
rou_CH = 0.0014; %the density of CH
K = 6;%the number of RCHs
Ro = 0.366*d; %the coverage radius of CCH
Rt = 0.233*K*sin(pi/K)*d; %the radius of RCH
Pr_t = 0.9; % the probability of successful transmission; TODO

%first generate the CHs
%the number of layers
num_layer = floor(d/Rc);
%the number of CHs per layer
num_CH = zeros(1,num_layer);
network = [];
%record the maximal level of CCH and RCH
num_level_CCH = 0;
num_level_RCH = 0;

for i = 1:num_layer
  %first the area of current layer
  S_cur = ((i+0.5)^2-(i-0.5)^2)*pi*Rc^2;
  num_CH(i) = ceil(S_cur * rou_CH);
  for j = 1:num_CH(i)
    %the ideal position of node (i,j)
    sita = 2*pi/num_CH(i)*(j-1);
    r = i*Rc;
    x = r*cos(sita);
    y = r*sin(sita);
    x = x + sqrt(5)*randn(1);
    y = y + sqrt(5)*randn(1);
    [sita r] = cart2pol(x,y);
    if r > Ro
      [dest, level] = cal_RCH_level(sita,r,K,Rc,Rt);
      newCH = generate_CH([sita r],dest,level,length(network)+1,0);
      if level > num_level_RCH
        num_level_RCH = level;
      end
    else
      newCH = generate_CH([sita r],0,i,length(network)+1,0);
      if i > num_level_CCH
        num_level_CCH = i;
      end
    end
    network = [network, newCH];
  end
end


%record the indices of the CH in each level of CCH
ind_CCH = zeros(sum(num_CH),num_level_CCH);
for i = 1:length(network)
  CH_tmp = network(i);
  if CH_tmp.dest == 0
    ind_CCH(CH_tmp.no,CH_tmp.level) = 1;
  end
end
ind_CCH = logical(ind_CCH);

%record the indices of the CHs in each level of RCH
ind_RCH = zeros(sum(num_CH),num_level_RCH);
for i = 1:length(network)
  CH_tmp = network(i);
  if CH_tmp.dest ~= 0
    ind_RCH(CH_tmp.no,CH_tmp.level) = 1;
  end
end
ind_RCH = logical(ind_RCH);

%routing
%first for the CHs heading to CCH
%the nodes in each layer will route its packet to the nearest node in its
%upper layer
for i = 2:num_level_CCH
    CH_cur_layer = network(ind_CCH(:,i));
    CH_upper_layer = network(ind_CCH(:,i-1));
    for j = 1:length(CH_cur_layer)
      dist_min = 10*Rc;
      ind_min = 0;
      for k = 1:length(CH_upper_layer)
          dist_tmp = cal_dist(CH_cur_layer(j),CH_upper_layer(k));
          if dist_tmp < dist_min
            dist_min = dist_tmp;
            ind_min = CH_upper_layer(k).no;
          end
      end
      network = add_route(network,CH_cur_layer(j).no,ind_min);
    end
end

%then consider CHs to RCH
%the position of RCHs are
%(0,Rt),(2pi/K,Rt),(2pi/K*2,Rt),...,(2pi/K*(K-1),Rt), no need to consider
%this?
for i = 2:num_level_RCH
    CH_cur_layer = network(ind_RCH(:,i));
    CH_upper_layer = network(ind_RCH(:,i-1));
    for j = 1:length(CH_cur_layer)
        dist_min = 10*Rc;
        ind_min = 0;
        for k = 1:length(CH_upper_layer)
            dist_tmp = cal_dist(CH_cur_layer(j),CH_upper_layer(k));
            if dist_tmp < dist_min
                dist_min = dist_tmp;
                ind_min = CH_upper_layer(k).no;
            end
        end
        network = add_route(network,CH_cur_layer(j).no,ind_min);
    end
end

drawNetwork(network,K,Rt);




