%% CalcCircMean Расчет вектора кругового среднего
%
% N количество слотов на окружности (на равных расстояниях)
% a сортированный в порядке возрастания вектор индексов из 1,...,N
%
% r вектор кругового среднего
function r = CalcCircMean (N, a)
start_angle = pi / 2; % start position
phi_start = (2/N)*pi*(0:N-1) + start_angle;

r = 1 / length(a) * [sum(cos(phi_start(a))) sum(sin(phi_start(a)))];
end
