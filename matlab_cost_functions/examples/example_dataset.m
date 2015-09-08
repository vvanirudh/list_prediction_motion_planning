%% 

clc;
clear;
close all;

data_set = '../../data_set_092714_3/';
epsilon = 20;

listing = dir(fullfile(data_set,'map*.mat'));

for i = 1:length(listing)
    load(strcat(data_set,listing(i).name), 'map');
    cost_map = create_obstacle_cost_map(map, epsilon);
    save(strcat(data_set, 'cost_map_',num2str(i),'.mat'), 'cost_map');
    figure;
    visualize_cost_map(cost_map);
    pause(0.1);
    saveas(gcf,strcat(data_set,'cost_map_',num2str(i),'.png'));
    pause(0.1);
    close all;
end


