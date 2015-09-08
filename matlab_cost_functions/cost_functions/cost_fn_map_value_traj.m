function cost_traj = cost_fn_map_value_traj( p_start, p_end, map )
%COST_FN_MAP_VALUE_TRAJ Summary of this function goes here
%   Detailed explanation goes here

idx = world_traj_to_grid( p_start, p_end, map );
c = map.table(sub2ind(size(map.table), idx(:,1), idx(:,2)));
cost_traj = sum((norm(p_end - p_start)/size(idx,1))*c);

end

