%% Calculate Circular Mean Vector and its length
%
% N is the total number of equispaced slots on a circle
% a is a sorted vector of unique numbers from 1,...,N
%
% r is the circular mean vector
function r = CalcCircMean (N, a)
start_angle = pi / 2; % start position
phi_start = (2/N)*pi*(0:N-1) + start_angle;

r = 1 / length(a) * [sum(cos(phi_start(a))) sum(sin(phi_start(a)))];
end
