function res = generate_CH(pos,dest,level,no,bFlag)
%generate a CH, where pos is its position, bFlag indicates whether it is
%a RCH/CCH or general CH

%pos is in polar coordinate 
%the properties include postion, the transmitting queue, the number of the
%next hop, the nodes that it will interfere 
res.pos = pos;
res.dest = dest; %0 for CCH, positive integers for RCHs
res.dist = 0;%the equivalent distance to destination
res.level = level;
res.no = no;
res.bFlag = bFlag;
res.queue = [];
res.next_hop = 0;
res.pos_next = 0; %distance to next hop
res.intf = [];
%res.carry = [];

%the running parameter
res.wait_time = 0;%the average waiting time of exponential distribution
res.silent = 0;


