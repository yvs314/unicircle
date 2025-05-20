% Total number of points
N = 8;
M = 0; % no. pre-placed points
K = 3; % no. points to place
L = M + K; % total filled slots

Ni = int16(N);
Mi = int16(M);
Ki = int16(K);
Li = Mi + Ki; % total points in solution, and total no. arc segments

%% Prep point locations as angles, just in case
start_angle = pi / 2; % start position
phi = (2/double(N))*pi*(0:N-1); % N angles, uniformly distributed on circle
phi_start = phi + start_angle;

baseline = CalcOptUniform(N, L); % hypthesized "most uniform" for L points

p = [5 6 7]; % pre-placed elements
s = [1 2 3]; % selected elements

if(~isempty(intersect(p,s)))
  error("Invalid solution: intersection between pre-placed and selected");
end

if(max(p) > N || max(s) > N)
  error("Element above N in p or s");
end

%PlotSolution(N, p, s);

