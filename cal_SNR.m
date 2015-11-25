function res = cal_SNR(network,trans_CH,trans_ind,pw,beta,Rc)
%first the received power
dist_next = cal_dist_pos(network(trans_ind),network(trans_ind).pos_next(1),network(trans_ind).pos_next(2));
pw_r = pw/(dist_next^beta)*exprnd(1);
intf_ind = (trans_CH ~= trans_ind);
intf_CH = network(trans_CH(intf_ind));
dist_intf = cal_dist_pos(intf_CH,network(trans_ind).pos_next(1),network(trans_ind).pos_next(2));
dist_intf = dist_intf(dist_intf < 8*Rc);
intf_r = pw./(dist_intf.^beta).*exprnd(1,size(dist_intf));%the interference from other CHs
res = pw_r/(1+sum(intf_r));
