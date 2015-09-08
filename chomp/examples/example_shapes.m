clc
clear
close all

%% Scenario
load ../maps/env1.mat

p_start = [0 0];
p_goal = [1 0];

figure(1);
visualize_shapes(shapes_array);

cntrl_pt = [p_start];
while(1)
    [x,y,button] = ginput(1);
    if (button == 3)
        break;
    end
    cntrl_pt = [cntrl_pt; x y];
end
cntrl_pt = [cntrl_pt; p_goal];
n = 50;
dcntrl_pt=diff(cntrl_pt,1,1);
d=sqrt(sum(dcntrl_pt.^2,2));
d=[0; cumsum(d)];
di=linspace(0,d(end),n);
xi=interp1(d,cntrl_pt,di);

%% Set up trajectory parameterization
% n = 100; %How many waypoints
% xi = [linspace(p_start(1),p_goal(1),n)' linspace(p_start(2),p_goal(2),n)'];


%% Cost functions
% Parameters
eta = 2000;
iter = 100;
lambda = 1;

[ A, b, c ] = smooth_matrices( p_start, p_goal, n - 2);
f_smooth = @(xi) cost_smooth( xi, A, b, c);
grad_smooth = @(xi) fsmooth(xi, A, b);  

epsilon = 0.05;
pt_c_obs_fn = @(pt) 100*squared_dist_shapes( pt, shapes_array, epsilon );
pt_cgrad_obs_fn = @(pt) 100*squared_dist_grad_shapes( pt, shapes_array, epsilon );

c_obs_fn = @(xi, xi_der) stacked_fn( xi, pt_c_obs_fn );
grad_cobs_fn = @(xi, xi_der) stacked_fn( xi, pt_cgrad_obs_fn );
grad_fobs = @(xi) grad_fn_arc_length( xi, c_obs_fn, grad_cobs_fn, p_start);
c_scalar_obs_fn = @(xi, xi_der) sum((1/(size(xi,1) + 1)).*sqrt(sum((xi_der).^2,2)) .* c_obs_fn(xi, xi_der));

c_final = @(xi, xi_der) lambda*f_smooth(xi) + c_scalar_obs_fn(xi, xi_der);
grad_final = @(xi, xi_der) lambda*grad_smooth(xi) + grad_fobs(xi);

options.eta = eta;
options.max_iter = iter;
options.min_iter = 10;
options.min_cost_improv_frac = 1e-5;
options.M = A;
options.decrease_wt = 1;


[ cost_traversal, time_taken, cost_history, traj_history, h_traj, h_cost ] = covariant_gradient_descent( xi, c_final, grad_final, options );
