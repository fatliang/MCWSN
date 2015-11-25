function network = SPRouting(network, K, Rt, Rc, beta)
interval = 2*pi/K;%the positions of RCHs are (interval*(i-1)+interval/2,Rt)
num_CH = length(network);

%for CCH and RCH
for k = 0:1:K
  if k == 0
    sita_dest = 0;
    rou_dest = 0;
  else
    sita_dest = interval*(k-1)+interval/2;
    rou_dest = Rt;
  end
  
  CH_array_CRCH = [];
  for i = 1:num_CH
    if network(i).dest == k;
      CH_array_CRCH = [CH_array_CRCH; network(i)];
    end
  end
  
  dist_array = [];
  for i = 1:length(CH_array_CRCH)
      dist_array = [dist_array; cal_dist_pos(CH_array_CRCH(i),sita_dest,rou_dest)];
  end

  [dist_array_sorted ind_dist_sorted] = sort(dist_array);%ind_dist_sorted stored the indices of corresponding CHs in CH_array_CCH
  CH_array_CRCH = CH_array_CRCH(ind_dist_sorted);
  
  CH_cur = CH_array_CRCH(1);
  network(CH_cur.no).next_hop = 0;
  network(CH_cur.no).dist = dist_array_sorted(1)^beta;
  
  for i = 2:length(CH_array_CRCH)
            
      CH_cur = CH_array_CRCH(i);
      dist_array_cur = dist_array_sorted(i)^beta;
      
      %better routing can be used here
      
      for j = 1:i-1
          
          dist_prev = cal_dist(CH_cur,CH_array_CRCH(j))^beta;
          no_prev = CH_array_CRCH(j).no;
          dist_prev = dist_prev + network(no_prev).dist;
          dist_array_cur = [dist_array_cur dist_prev];
          
      end
      
      [dist_min ind_min] = min(dist_array_cur);
      
      if ind_min == 1
          network(CH_cur.no).next_hop = 0;
          network(CH_cur.no).dist = dist_min;
      else
          network(CH_cur.no).next_hop = CH_array_CRCH(ind_min-1).no;
          network(CH_cur.no).dist = dist_min;
      end
  end
  
end



