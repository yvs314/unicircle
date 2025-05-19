%% Plot the solution
%
% * N is integer, the total number of slots
% * p is a sorted vector, 1 to N, unique, pre-placed points
% * s is a sorted vector, 1 to N, unique, solution

function retval = PlotSolution (N, p, s)
start_angle = pi / 2; % start position

phi = (2/N)*pi*(0:N-1);

phi_start = phi + start_angle;

hold on
axis("square", "off");
polar(phi_start, ones(size(phi_start)), "ok");
polar(phi_start(p), ones(size(p)), "*b")
polar(phi_start(s), ones(size(s)), "*r")
hold off
end
