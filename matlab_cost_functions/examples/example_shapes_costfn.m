clc;
clear;
close all;

% %% Create analytic world
load ../../matlab_environment_generation/saved_shape_arrays/bitstar_test.mat
figure;
hold on;
visualize_shapes(shapes_array);
grid on;
while(1)
    [x, y] = ginput(2);
    plot(x, y, 'b');
    cost_fn_shapes_traj(  [x(1) y(1)], [x(2) y(2)], shapes_array, 1e6)
    title('Hit return to continue');
    pause;
    clf;
    hold on;
    visualize_shapes(shapes_array);
    grid on;
end
