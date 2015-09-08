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
    [x, y] = ginput(1);
    scatter(x, y, 5, [0 0 1]);
    [collision, d, grad] = shapes_point_check( [x y], shapes_array );
    str = sprintf('Distance is %f , Grad is %f %f', d, grad(1), grad(2));
    title(str);
    pause;
    clf;
    hold on;
    visualize_shapes(shapes_array);
    grid on;
end
