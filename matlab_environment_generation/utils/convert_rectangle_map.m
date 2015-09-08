function [ map ] = convert_rectangle_map( shapes_array )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

bbox = [0 1 0 1];

rectangle_array = [];
for count = 1:length(shapes_array)
    r.low = shapes_array(count).data(1:2);
    r.high = shapes_array(count).data(1:2) + shapes_array(count).data(3:4);
    rectangle_array = [rectangle_array r];
end
resolution = 0.001;
map = rectangle_maps( bbox, rectangle_array, resolution);


end

