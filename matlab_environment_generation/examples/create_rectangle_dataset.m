%% This is to create an analytic set of piolygons (NOT MAP)

clc;
clear;
close all;

bbox = [0 1 0 1];
p_start = [0 0];
p_goal = [1 1];

side = 0.1;

padding = 30 + 2*side;
num = 20;
total_cases = 1000;

shapes_folder = '../../dataset/env_shapes_dataset/';
fig_folder = '../../dataset/env_figs/';
figure(1);
pause(1);
for case_count = 1:total_cases
    bbox_padded = [side -side side -side] + bbox;
    points = repmat([bbox_padded(1) bbox_padded(3)], num, 1) + repmat([bbox_padded(2)-bbox_padded(1) bbox_padded(4)-bbox_padded(3)], num, 1).*rand(num,2);
    points = [points; 0.5 0.5];
    shapes_array = [];
    for i = 1:size(points,1)
        shapes_array = [shapes_array get_rectangle_shape(points(i,1), points(i,2), side, side)];
    end
    
    save(strcat(shapes_folder,'env_',num2str(case_count),'.mat'), 'shapes_array');
    figure(1); clf; axis(bbox); visualize_shapes(shapes_array); pause(0.1);    
    saveas(gcf,strcat(fig_folder,'env_',num2str(case_count),'.png'));
    pause(0.1);
end


