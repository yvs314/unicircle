%% Calc Rao U
%
% Calculate Rao's test
% $0.5 \sum_{i=1}^L | \delta\theta_i - \frac{2\pi}{L}|
% half the sum of abs differences between angle step and uniform angle step
%
% Arguments
% * N is integer, number of equispaced slots on a circle
% * s is a vector of unique numbers from 1,...,N indicating which slots are taken

function RaoU = CalcRaoU (N, s)

phi = (2/double(N))*pi*(0:N-1); % N angles, uniformly distributed on circle

%% Solution to angles
theta  = phi(s); % solution as points' absolute angles,

%% Produce arc lengths between angles vector theta
theta_shl = circshift(theta, -1);
theta_shl_aug = [theta_shl(1:end-1) 2*pi + theta(1)];
% Compute arcs between points ("relative")
delta_theta_arcs = theta_shl_aug - theta; %last element is 2*pi - theta(1)

%% Rao's test
uniform_arcs = repmat(2*pi / length(theta), size(theta));

difference = abs(delta_theta_arcs - uniform_arcs);
RaoU = 0.5 * sum(difference);

end
