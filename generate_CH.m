function res = generate_CH(pos,node_num,bFlag)
%generate a CH, where pos is its position, bFlag indicates whether it is
%a RCH/CCH or general CH

%pos is in polar coordinate 
%the properties include postion, the transmitting queue, the number of the
%next hop, the nodes that it will interfere, the nodes that it will relay
%to the destination
res.pos = pos;
res.node_num = node_num;
res.bFlag = bFlag;
res.queue = [];
res.next_hop = 0;
res.interfere = [];
res.carry = [];

%the running parameter
res.wait_time = 0;
res.silent = 0;


