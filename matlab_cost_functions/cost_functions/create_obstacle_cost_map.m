function [ cost_map ] = create_obstacle_cost_map( map, epsilon )
%CREATE_OBSTACLE_COST_MAP Summary of this function goes here
%   Detailed explanation goes here


Dint = double(-bwdist(map.table));
Dext = double(bwdist(1-map.table));

Cint = -map.resolution*Dint;
Cext = (1.0/(2.0*epsilon))*((min(Dext*map.resolution-epsilon, 0)).^2);

cost_map = map;
cost_map.table = Cint + Cext;

end

