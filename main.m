%network
%parameters
d = 300; %the radius of the whole area
Rc = 30; %the communication range of CH, which is also the distribution interval of CHs
rc = 15; %the communication range of node
beta = 2; %the fading coefficient
gamma = 5; %the transmission threshold, in dB
Nintf = 2; %the CSMA sensing range is Nintf*Rc, remark: it should be higher when beta = 2
rou_CH = 0.0014; %the density of CH
K = 6;%the number of RCHs
Ro = 0.366*d; %the coverage radius of CCH
Rt = 0.233*K*sin(pi/K)*d; %the radius of RCH
%Pr_t ; % the probability of successful transmission; TODO

%first generate the CHs
%the number of layers
num_layer = floor(d/Rc);
%the number of CHs per layer
num_CH = zeros(1,num_layer);
network = [];
for i = 1:num_layer
  %first the area of current layer
  S_cur = (i^2-(i-1)^2)*pi*Rc^2;
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
    newCH = generate_CH([sita r],length(network)+1,0);
    network = [network, newCH];
  end
  
end
drawNetwork(network);
