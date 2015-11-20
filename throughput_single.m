function res = throughput_single(K, Nfreq, Nintf, Nch, gamma, SNR, Nhop)
%here SNR is the received SNR of each hop, and decode forward is used

Pt = (K+1)*Nfreq/(Nintf*Nch); %transmission probability
P_succ = exp(-Nhop*gamma./SNR);
res = Pt*P_succ;