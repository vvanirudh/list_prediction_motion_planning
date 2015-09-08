function idx = world_wp_to_grid( traj, map )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

idx = round((traj-repmat(map.origin, [size(traj,1) 1]))/map.resolution);
idx(:,1) = min(size(map.table,1), max(1, idx(:,1)));
idx(:,2) = min(size(map.table,2), max(1, idx(:,2)));

end

