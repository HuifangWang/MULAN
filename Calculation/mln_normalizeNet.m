function net=mln_normalizeNet(net1)

maxnet=max(max(abs(net1)));
net=net1/maxnet;