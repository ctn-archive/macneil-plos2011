% In the lines below, change <dir> to the install path of the OMS model
% addpath '<dir>/OMS_Model_V1_4/Sacc mfiles/' 
% addpath '<dir>/OMS_Model_V1_4/SP mfiles/'

% Set network and cellular parameters for neural population
ms = 1e-3;

N = 40;             % neurons
D = 1;              % dimensions
sigma = 0.1;        % sigma for noise added to gamma
domain = [-1 1];    % domain of input
range = [20 100];   % range of max firing rates

tauRC = 100*ms;     % neuron time constant (large to approximate
                    % linear dynamics of goldfish neurons    
tauRef = 2*ms;      % refractory period
tauSyn = 100*ms;    % synaptic time constant

A = eye(D);         % feedback gain = 1
B = tauSyn*eye(D);  % input matrix for integrator

dx = 0.001;         % dx for optimial phi calculation

% Get parameters of neural population and find optimal decoders
% returns: 
%    decoder encoder inputCurrentGain biasCurent activitys inputs
[phi phiT alpha jBias a x] =...    
    setPop(domain, range, tauRC, tauRef,sigma, N, D, dx, @(x)x);

phi_o = phi; % optimal phi
light = 1; % light on;
distortion = 0; % No feedback distortion (ie stationary visual field)
    
% add 15% noise to phi
W = alpha.*phiT*phi';
W = W.*(1+0.15*randn(size(W)));
phi = (pinv(alpha.*phiT)*W)';


noise = 0.0;    % No noise added during simulation.
                %
                % A positive number will add the specified amount of noise
                % to the connection weights of over a simulated time of 20
                % minutes concurrently with learning.
                %
                % A negative number will add the specified amount of noise
                % to the the connection weigths without learning.
                %
                % eg.   -0.3 for 30% noise, no learning
                %        0.3 for 30% noise with learning
                
% call simulink to run the simution for 100 seconds                
sim('OMSv1_4_mod_NEF_NI', 100);

% save outputs
signalData = muxout; % contains input and output of the system
phiData = phiOut; % decoder values throughout simulation

% plot various decoders
figure(1);

optimalDecoder = 1.*(sum(a.*(phi_o*ones(1,length(x))))-x)+x;
noisyDecoder = 1.*(sum(a.*(phi*ones(1,length(x))))-x)+x;
learnedDecoder = 1.*(sum(a.*(phiData(size(phiData,1), :)'*ones(1,length(x))))-x)+x;

plot(x,x, 'k', x, optimalDecoder, 'm',...
    x, noisyDecoder, 'g',...
    x, learnedDecoder, 'b');
legend('x', 'Optimal', 'Noisy', 'Learned', 'Location', 'NorthWest');
xlabel('Ideal Position');
ylabel('Represented Position');
title('Normalized Eye Position');
    
% plot animation of decoder over time
figure(2);

for i = 1:10:size(phiData,1)
    h = figure(2);
    phi = phiData(i,:)';
    plot(x,x, 'b', x, sum(a.*(phi*ones(1,length(x)))),'c');
    ylim([-1.2,1.2]);
    xlabel('Ideal Position');
    ylabel('Represented Position');
    title('Normalized Eye Position');
    text(-0.8, 1, num2str(i/10));
    pause(0.01);
end;
