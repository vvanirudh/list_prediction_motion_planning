function [ shapes_array ] = get_project_shapes_array( )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

bbox = [0 1 0 1];
side = 0.1;
num = 20;
bbox_padded = [side -side side -side] + bbox;
points = repmat([bbox_padded(1) bbox_padded(3)], num, 1) + repmat([bbox_padded(2)-bbox_padded(1) bbox_padded(4)-bbox_padded(3)], num, 1).*rand(num,2);
points = [points; 0.5 0.5];
shapes_array = [];
for i = 1:size(points,1)
    shapes_array = [shapes_array get_rectangle_shape(points(i,1), points(i,2), side, side)];
end

end

