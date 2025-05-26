N = 16; % no. equispaced slots on a circle

p = sort([1 3 6 7]); % pre-placed elements, indexed 1,...,N
M = length(p); % no. occupied slots
K = 5; % no. points to place
L = M + K; % no. occupied slots including solution

rho = (M + K) / N; % "occupancy rate" of slots in the overall solution

if length(p) ~= M || length(unique(p)) ~= M || min(p) < 1 || max(p) > N
  error("Invalid input: check pre-placed elements");
end

Ni = int16(N);
Mi = int16(M);
Ki = int16(K);
Li = Mi + Ki; % total points in solution, and total no. arc segments

%% Prep point locations as angles, just in case
start_angle = pi / 2; % start position
phi_start = (2/N)*pi*(0:N-1) + start_angle; % N equispaced angles on a circle

 % Heuristic near-uniform if no slots were occupied (if M = 0)
baseline = CalcHeurUniform(N, L);

%% Find a solution
% s = solve(N, K, p); %solve call placeholder
% expect p to be sorted
p_aug = [p N + p(1)];
p_aug_shl = circshift(p_aug, -1);
p_segs = p_aug_shl - p_aug;
slots = (p_segs - 1)(1:end-1);

if sum(slots) ~= N - M
  error("Invalid result: slot count does not match M - K");
end

% combined slot counts, start, and end indices
%C = [slots; demand; extra_slots; p_aug(1:end-1); p_aug_shl(1:end-1)];
C = [slots; p_aug(1:end-1); p_aug_shl(1:end-1)];
% C(1,:) is free slots in segment
% C(2,:) is start indices (first free slot in segment)
% C(3,:) is end indices (last free slot in segment)

% sortrows(A, [-1]) is Octave for sort by first column descending
% Matlab equivalent is sortrows(A, 1, "descending")
% C_sort is C sorted by free slots in each segment, descending
C_sort = sortrows(C', [-1])';
% C_sort(1,:) is free slots in segment
% C_sort(2,:) is start indices (first free slot in segment)
% C_sort(3,:) is end indices (last free slot in segment)

demand_floor = floor(C_sort(1,:) * rho); % how many points to put into each segment
% due to floor, some have been left unassigned
leftover = K - sum(demand_floor);

% where can we stuff the leftover; larger segments come first due to sort
extra_slots = C_sort(1,:) - demand_floor;

if sum(extra_slots) < leftover
  error("Can't fit leftover points into available slots");
end

available_extra_slots = find(extra_slots); % indices of nonzero elements
% put 1 each into available extra slots until leftover is exhausted
addenda = available_extra_slots(1:leftover);
extd_addenda = zeros(size(extra_slots));
extd_addenda(addenda) = 1;

demand = demand_floor + extd_addenda;

% insert the demand row into C_sort
C_demand = [C_sort(1,:); demand; C_sort(2:end,:)]
% C_demand(1,:) is free slots in segment
% C_demand(2,:) is "demand" in segment (how many slots to fill)
% C_demand(3,:) is start indices (slot before first free slot in segment)
% C_demand(4,:) is end indices (slot after last free slot in segment)

%% All is ready for determining how to uniformly spread allotted demand
% For a segment j,
% Spread C_demand(2,j) between C_demand(3,j) and C_demand(4,j), inclusively
% This is done by translating CalcHeurUniformSegment
% between C_demand(3,j) to C_demand(4,j)
% with C_demand(1,j) as total slots and C_demand(2,j) as points to fill in
s_acc = []; % start as empty vector

for column = 1:size(C_demand,2) % for each column
  w = CalcHeurUniformSegment(C_demand(1,column), C_demand(2,column));
  s_acc = [s_acc w + C_demand(3,column)];
end

%% Finalize indexing and sort
% s_acc - 1 switches to 0-indexing, for compatibility with mod N (N mod N is 0)
% adding + 1 to results of mod N restores 1-indexing
s = sort(mod(s_acc - 1,N) + 1)

if ~isempty(intersect(p,s))
  error("Invalid solution: intersection between pre-placed and selected");
end

if max(p) > N || max(s) > N
  error("Element above N in p or s");
end

if length(s) ~= length(unique(s))
  error("Nonunique elements in s");
end

if length(sort(p)) ~= length(unique(sort(p)))
  error("Nonunique elements in p");
end

overall = sort([p s]); % all occupied slots

PlotSolution(N, p, s);
r = CalcCircMean(N, overall);
r_p = CalcCircMean(N, p);
disp(["Starting mean vector length is " num2str(norm(r_p))]);
disp(["Solution mean vector length is " num2str(norm(r))]);

