clc;
clear;
close all;

% %% Create analytic world
load ../saved_shape_arrays/bitstar_test.mat
figure;
hold on;
visualize_shapes(shapes_array);
grid on;
while(1)
    [x, y] = ginput(2);
    plot(x, y, 'b');
    collision = shapes_collision_check( [x(1) y(1)], [x(2) y(2)], shapes_array );
    if (collision)
        title('Collision!! Hit return to continue');
    else
        title('Free!! Hit return to continue');
    end
    pause;
    clf;
    hold on;
    visualize_shapes(shapes_array);
    grid on;
end
