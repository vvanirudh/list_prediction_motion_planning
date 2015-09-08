function [ cost_map_x, cost_map_y, cost_map_xx, cost_map_yy, cost_map_xy ] = get_cost_map_derivatives( cost_map )
%GET_COST_MAP_DERIVATIVES Summary of this function goes here
%   Detailed explanation goes here

cost_map_x = cost_map;
cost_map_y = cost_map;
cost_map_xx = cost_map;
cost_map_yy = cost_map;
cost_map_xy = cost_map;

[Cy,Cx] = gradient(cost_map.table/cost_map.resolution);
[Cyx, Cxx] = gradient(Cx/cost_map.resolution);
[Cyy, Cxy] = gradient(Cy/cost_map.resolution);

cost_map_x.table = Cx;
cost_map_y.table = Cy;
cost_map_xx.table = Cxx;
cost_map_yy.table = Cyy;
cost_map_xy.table = 0.5*(Cxy + Cyx); %forcing symmetry
end

