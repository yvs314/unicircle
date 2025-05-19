% Total number of points
N = 8;

%M = 0; % no. pre-placed points
%K = 3; % no. points to place

p = [5 6 7]; % pre-placed elements
s = [1 2 3]; % selected elements

if(~isempty(intersect(p,s)))
  error("Invalid solution: intersection between pre-placed and selected");
end

if(max(p) > N || max(s) > N)
  error("Element above N in p or s");
end

PlotSolution(N, p, s);

