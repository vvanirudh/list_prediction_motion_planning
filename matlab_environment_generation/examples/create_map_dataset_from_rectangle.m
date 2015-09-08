clc;
clear;
close all;

data_set = '../../dataset/env_shapes_dataset/';
output_data_set = '../../dataset/env_map_dataset/';
bbox = [0 1 0 1];
listing = dir(fullfile(data_set,'env*.mat'));
for i = 1:length(listing)
    load(strcat(data_set,'env_',num2str(i),'.mat'), 'shapes_array');
    rectangle_array = [];
    for count = 1:length(shapes_array)
        r.low = shapes_array(count).data(1:2);
        r.high = shapes_array(count).data(1:2) + shapes_array(count).data(3:4);
        rectangle_array = [rectangle_array r];
    end
    resolution = 0.001;
    map = rectangle_maps( bbox, rectangle_array, resolution);
    save(strcat(output_data_set, 'map_',num2str(i),'.mat'), 'map');
end

