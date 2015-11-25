%network
%parameters
%need to consider the real SNR!
Rc = 30; %the communication range of CH, which is also the distribution interval of CHs
rc = 15; %the communication range of node
beta = 2; %the fading coefficient
gamma = 5; %the transmission threshold, in dB
SNR = 8; %the ideal SNR, in dB

Nintf = 2; %the CSMA sensing range is Nintf*Rc, remark: it should be higher when beta = 2
rou_CH = 0.0014; %the density of CH
K = 6;%the number of RCHs

Nfreq = 1;

pw = 10^(SNR/10)*(Rc^beta);%the transmitting power, noise power is normalized
threshold = 10^(gamma/10);

d_array = [300];
throughput_simul = zeros(1,length(d_array));
throughput_theor = zeros(1,length(d_array));

for ind_d = 1:length(d_array)
        
    d = d_array(ind_d); %the radius of the whole area
    
    Ro = 0.366*d; %the coverage radius of CCH
    Rt = 0.233*K*sin(pi/K)*d; %the radius of RCH
    Pr_t = exp(-10^((gamma-SNR)/10)); % the probability of successful transmission; TODO
    
    
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
    
    network = addIntf(network,Rc,Nintf);
    network = initNet(network,K,Rt);
    drawNetwork(network,K,Rt);
        
    %real simulation
    CH_array = [1:length(network)];
    num_rounds = 20000;
    
    received_CCH = zeros(length(network),1);
    received_RCH = zeros(length(network),K);
    
    wait_time_av = zeros(length(network),1);
    for i = 1:length(network)
        wait_time_av(i) = network(i).wait_time;
    end
    
    for i = 1:num_rounds
        %first the CSMA phase
        %generate the waiting time
        trans_CH = [];
        wait_time = exprnd(wait_time_av);
        [time_min ind_min] = min(wait_time);
        
        while time_min < inf
            %then ind_min transmits
            network(ind_min).silent = 0;
            trans_CH = [trans_CH ind_min];
            wait_time(ind_min) = inf;
            CH_tmp = network(ind_min);
            %make other interfering CHs silent
            for j = 1:length(CH_tmp.intf)
                wait_time(CH_tmp.intf(j)) = inf;
                network(CH_tmp.intf(j)).silent = 1;
            end
            [time_min ind_min] = min(wait_time);
        end
        
        %start to transmit
        for j = 1:length(trans_CH)
            %deque first packet in its queue
            ind_trans = trans_CH(j);
            
            %randomly select the packets in queue
            packets_wait = CH_array(network(ind_trans).queue > 0);
            packets_wait = [packets_wait ind_trans];
            packets_wait = packets_wait(randperm(length(packets_wait)));%random sorting
            packet = packets_wait(1);
            %
            
            if packet ~= ind_trans
                network(ind_trans).queue(packet) = network(ind_trans).queue(packet)-1;
            end
            
            %for test
            if sum(network(ind_trans).queue < 0) > 0
                disp('error');
            end
            
            %try whether the packet transmitted successfully
%             prob_test = rand(1);
%             if prob_test > Pr_t
%                 %fail in this case
%                 continue;
%             end

            SINR_r = cal_SNR(network,trans_CH,ind_trans,pw,beta,Rc);
            
            %judge whether the transmission succeeds
            if SINR_r < threshold
              continue;
            end
            
            ind_next = network(ind_trans).next_hop;
            
            if ind_next ~= 0
                network(ind_next).queue(packet) = network(ind_next).queue(packet)+1;
            elseif network(ind_trans).dest == 0
                received_CCH(packet) = received_CCH(packet)+1;
            else
                received_RCH(packet,network(ind_trans).dest) = received_RCH(packet,network(ind_trans).dest)+1;
            end
            
        end
        
        for i = 1:length(network)
            wait_time_av(i) = network(i).wait_time/(1 + sum(network(i).queue > 0));
        end
    end
    
    %calculate the throughput
    received_all = received_CCH+sum(received_RCH,2);
    throughput_simul(ind_d) = mean(received_all)/num_rounds;
    
    %theoretical value
    dist_square_av = d.^2.*(0.5-0.047*K.^2.*(sin(pi./K)).^2);%the average distance from CH to destination
    Nhop = sqrt(dist_square_av)/Rc;
    Nch = length(network);
    throughput_theor(ind_d) = throughput_single(K, Nfreq, Nintf, Nch, 10^(gamma/10), 10^(SNR/10), Nhop); 
end
figure();
semilogy(d_array,throughput_simul,'-rx');
hold on;
%theoretical value
semilogy(d_array,throughput_theor,'-bo');
grid on;
title_str = sprintf('K=%d, SNR=%d dB, gamma=%d dB',K,SNR,gamma);
title(title_str);
xlabel('Cell radius(m)');
ylabel('Per node throughput(packets/slot)');
legend('Simulation results','Theoretic values');



