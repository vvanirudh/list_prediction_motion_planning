function cost = cost_fn_map_value( x, map )
%COST_FN_MAP_VALUE Summary of this function goes here
%   Detailed explanation goes here

[ r, c ] = world_to_grid( x(1), x(2), map );
r = min(size(map.table,1), max(1,r));
c = min(size(map.table,2), max(1,c));
cost = map.table(r,c);
end

