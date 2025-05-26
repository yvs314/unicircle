N = 12; % no. equispaced slots on a circle

p = sort([1 3 6 7]); % pre-placed elements, indexed 1,...,N
M = length(p); % no. occupied slots
K = 5; % no. points to place
L = M + K; % no. occupied slots including solution

rho = (M + K) / N; % "occupancy rate" of slots in the overall solution

if length(p) ~= M || length(unique(p)) ~= M || min(p) < 1 || max(p) > N
  error("Invalid input: check pre-placed elements");
end

%% Find a solution
s = SolveRho(N, K, p);

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

