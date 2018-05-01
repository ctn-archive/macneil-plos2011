function [phi phiT alpha jBias a x] = ...
    setPop(domain, range, tauRC, tauRef,sigma, N, D, dx, fnc)

Jth = 1; % threshold current

% x intercepts of firing curves
x_int = domain(1)*1.0 + (domain(2)-domain(1)*1.0).*rand(N,1);
% maximum rates of firing curves
y_max = range(1)+(range(2)-range(1)).*rand(N,1);

phiT = encWeights(D,N); % encoders, 1 and -1

% solve LIF equations
J_max = Jth./(1-exp((tauRef-1./y_max)./tauRC));
alpha = (J_max)./((domain(2)-x_int));
jBias = J_max - alpha*domain(2);

% get even distribution of inputs in D dimensions
x = getXdist(domain, D, dx);
M = length(x);

J = alpha*ones(1,M).*(phiT*x) + jBias*ones(1, M);
a = (1./(tauRef-tauRC*log(1-1./J))).*(J>1);

% plot firing curves
%figure(1);
%plot(x,a');

% solve for decoders
gamma = a*a'*dx + sigma^2*range(2)*eye(N);
upsilon = a*fnc(x)'*dx;
phi = pinv(gamma)*upsilon;
%phi = a'\x';

