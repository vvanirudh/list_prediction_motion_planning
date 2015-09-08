clc;
clear;
close all;

%% Create analytic world
bbox = [0 240 0 171.5];
p_start = [6 95];
p_goal = [237.5000 95.0000];
side = 10;
padding = 30 + 2*side;
num = 15;
resolution = 0.5;
total_cases = 1000;

folder = '../../data_set_091914_2/';

case_count = 1;
while (case_count <= total_cases)
    bbox_padded = [side -side side -side] + bbox;

    init_n = poissrnd(num);
    points = repmat([bbox_padded(1) bbox_padded(3)], init_n, 1) + repmat([bbox_padded(2)-bbox_padded(1) bbox_padded(4)-bbox_padded(3)], init_n, 1).*rand(init_n,2);

    %% Pad around start to goal
    count = 0;
    closest_distance = Inf;
    for i = 1:init_n
        if (norm(points(i,:) - p_start) < padding)
            continue;
        end
        if (norm(points(i,:) - p_goal) < padding)
            continue;   
        end

        distance = norm((p_start - points(i,:)) - ((p_start - points(i,:))*(p_goal - p_start)')*(p_goal - p_start)/(((p_goal - p_start)*(p_goal - p_start)')));
        if (distance < closest_distance)
            closest_distance = distance;
        end

        count = count + 1;
        rectangle_array(count).low = [points(i,1)-side points(i,2)-side];
        rectangle_array(count).high = [points(i,1)+side points(i,2)+side];
    end

    if (closest_distance > side)
        continue;
    end

    map = rectangle_maps( bbox, rectangle_array, resolution);
    
    save(strcat(folder,'map_',num2str(case_count),'.mat'), 'map');
    figure;
    visualize_map(map);
    pause(0.1);
    saveas(gcf,strcat(folder,'map_',num2str(case_count),'.png'));
    pause(0.1);
    close all;
    case_count = case_count + 1;
end
%% Admire work
figure;
visualize_map(map);