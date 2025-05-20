%% Calculate Optimal Uniform distribution
%
% This function determines the hypothesized (YS) best indices for positioning
% Indices are assumed (YS) to be the closest to discrete uniform distribution
% of L points on circle where N equispaced slots are available, $N \geq L$.
% "Closeness" is considered in Rao's test terms
%
% Rao's test: absolute coordinatewise difference between
%   * the vector of uniform angles with step 2pi / N
%   * and input angles (computed from integer positions from 1,...,N)


function baseline = CalcOptUniform (N, L)
Ni = int16(N); % Total number of slots
Li = int16(L); % Total points in solution, and total no. arc segments

if(Ni < Li)
  error("Too many points for available slots");
end

base_arc_length = idivide(Ni, Li);
remainder = mod(Ni, Li); % how much to distribute among arcs, one to each

% Base arc length is Ni / Li (integer quotient), spread evenly
w_base = repmat(base_arc_length, 1, Li);
% Spread the remainder evenly, one per arc, until used up
addendum = [ones(1, remainder), zeros(1, Li - remainder)];

% Best integer arc lengths distribution with respect to Rao's test
% (hypothesized, YS). Naturally sorted in descending order
w = w_base + addendum;

% Get point indices from arc lengths
baseline_biased = cumsum(w); % point indices, starting with largest arc length
baseline = cumsum(w) - w(1) + 1; % shift left to start with 1
end
