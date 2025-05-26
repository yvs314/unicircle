%% SolveRho
%
% Place K points into N - length(p) slots while heuristically attempting to
% maintain the "occupancy rate" $rho := (M + K) / N$. It is expected that
% this minimizes the circular mean vector.
%
% Inputs:
%   * N (integer) is total number of slots
%   * K (integer) is how many points to place
%   * p (sorted vector of unique indices from 1,...,N) is vector of occupied slots
% Inputs are assumed to be correct, and must be sanitized by the caller.
%
% Output: s is a vector of K indices from 1,...,N

function s = SolveRho(N, K, p)
M = length(p); % no. occupied slots
L = M + K; % no. occupied slots including solution
rho = (M + K) / N; % "occupancy rate" of slots in the overall solution

%% Find a solution
% expect p to be sorted
p_aug = [p N + p(1)];
p_aug_shl = circshift(p_aug, -1);
p_segs = p_aug_shl - p_aug;
slots = (p_segs - 1)(1:end-1);

if sum(slots) ~= N - M
  error("Invalid result: slot count does not match M - K");
end

% combined slot counts, start, and end indices
C = [slots; p_aug(1:end-1); p_aug_shl(1:end-1)];
% C(1,:) is free slots in segment
% C(2,:) is start indices (slot before first free slot in segment)
% C(3,:) is end indices (slot after last free slot in segment)

% C_sort is C sorted by free slots in each segment, descending
C_sort = sortrows(C', [-1])';
% sortrows(A, [-1]) is Octave for sort by first column descending
% Matlab equivalent is sortrows(A, 1, "descending")

%% Allocate K points to the available slots in segments
demand_floor = floor(C_sort(1,:) * rho); % how many points to put into each segment
% due to floor, some have been left unassigned
leftover = K - sum(demand_floor);

% Where can we stuff the leftover; larger segments come first due to sort order
extra_slots = C_sort(1,:) - demand_floor;

if sum(extra_slots) < leftover
  error("Can't fit leftover points into available slots");
end

available_extra_slots = find(extra_slots); % indices of nonzero elements
% put 1 each into available extra slots until leftover is exhausted
addenda = available_extra_slots(1:leftover);
extd_addenda = zeros(size(extra_slots));
extd_addenda(addenda) = 1;
% final allocation of points to segments
demand = demand_floor + extd_addenda;

% insert the demand row into C_sort
C_demand = [C_sort(1,:); demand; C_sort(2:end,:)]
% C_demand(1,:) is free slots in segment
% C_demand(2,:) is "demand" in segment (how many slots to fill)
% C_demand(3,:) is start indices (slot before first free slot in segment)
% C_demand(4,:) is end indices (slot after last free slot in segment)

%% All is ready for determining how to uniformly spread allocated demand
% For a segment j,
% Spread C_demand(2,j) between C_demand(3,j) and C_demand(4,j), exclusively
% This is done by translating CalcHeurUniformSegment
% between C_demand(3,j) to C_demand(4,j)
% with C_demand(1,j) as total slots and C_demand(2,j) as points to fill in
s_acc = []; % start with empty vector

for column = 1:size(C_demand,2) % for each column
  w = CalcHeurUniformSegment(C_demand(1,column), C_demand(2,column));
  s_acc = [s_acc w + C_demand(3,column)];
end

%% Finalize indexing and sort
% s_acc - 1 switches to 0-indexing, for compatibility with mod N (N mod N is 0)
% adding + 1 to results of mod N restores 1-indexing
s = sort(mod(s_acc - 1,N) + 1)

end
