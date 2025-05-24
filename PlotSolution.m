%% Plot the solution
%
% * N is integer, the total number of slots
% * p is a sorted vector, 1 to N, unique, pre-placed points
% * s is a sorted vector, 1 to N, unique, solution

function retval = PlotSolution (N, p, s)

overall = sort([p s]);
L = length(overall);

start_angle = pi / 2; % start position

phi = (2/N)*pi*(0:N-1);

phi_start = phi + start_angle;

% circular mean vector for p
r_phi_p_start = 1 / length(p) * [sum(cos(phi_start(p))) sum(sin(phi_start(p)))];

% circular mean vector for s
r_phi_s_start = 1 / length(s) * [sum(cos(phi_start(s))) sum(sin(phi_start(s)))];

% circular mean vector of occupied positions
r_phi_overall_start = 1 / length(overall) * [sum(cos(phi_start(overall)))  sum(sin(phi_start(overall)))];

hold on
axis("square", "off");
polar(phi_start, ones(size(phi_start)), "ok");
polar(phi_start(p), ones(size(p)), "*b");
polar(phi_start(s), ones(size(s)), "*r");
plot([0 r_phi_p_start(1)], [0 r_phi_p_start(2)], ":.b");
plot([0 r_phi_s_start(1)], [0 r_phi_s_start(2)], ":.r");
plot([0 r_phi_overall_start(1)], [0 r_phi_overall_start(2)], ":.k");
end
