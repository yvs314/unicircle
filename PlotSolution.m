%% PlotSolution график решения
%
% * N целое число, количество мест под точки (слотов)
% * p сортированный вектор чисел из 1,...,N, исходно занятые слоты
% * s сортированный вектор чисел из 1,...,N, решение
% Аргументы предполагаются корректными
%
% Слоты обозначеные белыми кружками с черной обводкой, "ok"
% Исходно занятые слоты обозначены синими звездочками, "*b"
% Решение (размещенные точки) обозначены красными звездочками, "*r"
%
% Вектора кругового среднего исходят из начала координат, даны линиями из точек
% и заканчиваются более крупной точкой.
% Синий вектор ":.b" рассчитан из исходных точек p
% Красный вектор ":.r" рассчитан из решения s
% Черный вектор ":.k" рассчитан из общего положения (конкатенация s и p)


function retval = PlotSolution (N, p, s)

overall = sort([p s]);

start_angle = pi / 2; % начало отсчета
phi_start = (2/N)*pi*(0:N-1) + start_angle;

r_phi_p_start = CalcCircMean(N, p); % круговое среднее для p
r_phi_s_start = CalcCircMean(N, s); % круговое среднее для s
r_phi_overall_start = CalcCircMean(N, overall); % общее круговое среднее

hold on
axis("square", "off");
polar(phi_start, ones(size(phi_start)), "ok");
polar(phi_start(p), ones(size(p)), "*b");
polar(phi_start(s), ones(size(s)), "*r");
plot([0 r_phi_p_start(1)], [0 r_phi_p_start(2)], ":.b");
plot([0 r_phi_s_start(1)], [0 r_phi_s_start(2)], ":.r");
plot([0 r_phi_overall_start(1)], [0 r_phi_overall_start(2)], ":.k");
end
