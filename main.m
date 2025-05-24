N = 8; % no. equispaced slots on a circle
M = 3; % no. occupied slots
K = 3; % no. points to place

p = sort([5 6 7]); % pre-placed elements, indexed 1,...,N
if(length(p) ~= M || length(unique(p)) ~= M || min(p) < 1 || max(p) > N)
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

% s = solve(N, K, p); %solve call placeholder
s = [1 2 3]; % selected elements

if(~isempty(intersect(p,s)))
  error("Invalid solution: intersection between pre-placed and selected");
end

if(max(p) > N || max(s) > N)
  error("Element above N in p or s");
end

if(length(s) ~= length(unique(s)))
  error("Nonunique elements in s");
end

if(length(sort(p)) ~= length(unique(sort(p))))
  error("Nonunique elements in p");
end

PlotSolution(N, p, s);

