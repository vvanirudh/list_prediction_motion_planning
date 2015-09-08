function [ r, c ] = world_to_grid( x_world, y_world, map )
%WORLD_TO_GRID Convert a 
%   Detailed explanation goes here

r = 1+round((x_world - map.origin(1))/map.resolution);
c = 1+round((y_world - map.origin(2))/map.resolution);

end

