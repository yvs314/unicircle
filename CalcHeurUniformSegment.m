%% Calculate Heuristic Uniform distribution on a segment
%
% This function determines heuristic uniform distribution for L points out of N slots
%
% The points and slots are located on a line segment (stand-in for arc segment)
% equispaced from 1 to N. Slots 0 and N+1 are assumed to be taken, and segments
% [0, first_point] and [last_point N+1] are taken into account when distributing
% the points on the segment.
%
% In this statement, the L point positions define L + 1 segments

% It is expected (YS) that this solution approaches the true uniform as N increases.
% It is a perfect solution when N + 1 / L + 1 is integer (no remainder).
%
% Solution quality is mean segment length, compared with N + 1 / L + 1, which
% is the "ideal" case possible if the L points were on continuous [1, N]
% rather than on the discrete 1,...,N.

function w = CalcHeurUniformSegment (N, L)

if(N < L)
  error("Too many points for available slots");
end

Ni = int16(N); % Total number of slots
supp = 0:N+1; % 0 and N+1 are occupied; 1,...,N are open slots
Li = int16(L); % Total points in solution
seg_count = Li+1; % 0-> L points -> N+1 make for L+1 segments

base_seg_length = idivide(Ni+1, Li+1);
remainder = mod(Ni+1, Li+1); % how much to distribute among arcs, one to each

% Base segment length is Ni + 1 / Li + 1 (integer quotient), spread evenly
rep_base = repmat(base_seg_length, 1, Li + 1);
% Spread the remainder evenly, one per segment, until used up
addendum = [ones(1, remainder), zeros(1, Li + 1 - remainder)];

% Heuristic discrete uniform segment lengths.
% Naturally sorted in descending order.
seg_lengths = rep_base + addendum;

% Get point indices from segment lengths, ignoring 0 and N+1
w = cumsum([0 seg_lengths])(2:end-1);
end
