%% Calculate Heuristic Uniform distribution on a circle
%
% This function determines heuristic uniform distribution for L out of N slots,
% where N is the total number and L are free to be filled with *no* pre-placed.
%
% Indices are based on imperfect "discrete uniform" successive arc lengths
% that are meant to approximate the truly uniform arcs $2\pi / L$ with the N
% discrete slots available.
%
% It is expected (YS) that this solution approaches the true uniform as N increases.
% It is a perfect solution when N / L is integer (no remainder).
%
% Solution quality is in terms of circular mean vector norm,
% the smaller the better (it ranges 0 to 1), see CalcCircMean.m

function baseline = CalcHeurUniform (N, L)
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
