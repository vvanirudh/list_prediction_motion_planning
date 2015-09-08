function idx = world_traj_to_grid( p_start, p_end, map )
%WORLD_TRAJ_TO_GRID Summary of this function goes here
%   Detailed explanation goes here

alpha = linspace(0, 1, 2 + floor(norm(p_end - p_start)/map.resolution))';
traj = repmat(p_start, [length(alpha), 1]).*repmat(alpha, [1 length(p_start)]) + repmat(p_end, [length(alpha), 1]).*repmat(1-alpha, [1 length(p_end)]);
idx = round((traj-repmat(map.origin, [size(traj,1) 1]))/map.resolution);

idx(:,1) = min(size(map.table,1), max(1, idx(:,1)));
idx(:,2) = min(size(map.table,2), max(1, idx(:,2)));

end

