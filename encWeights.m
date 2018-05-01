% get even distribution of -1 and 1
function phiT = encWeights(dims, N)

phiT = -1 +2.*rand(N, dims);
magnitude = sqrt(sum(phiT.^2,2))*ones(1,dims);
phiT = phiT./magnitude;

    