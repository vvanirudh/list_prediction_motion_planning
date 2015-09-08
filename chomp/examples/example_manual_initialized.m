clc
clear
close all

load ../../matlab_cost_functions/saved_cost_maps/cost_map_convex_opt_proj.mat
p_start = [0 0];
p_goal = [1 1];

figure(1);
hold on;
visualize_cost_map(cost_map);

cntrl_pt = [p_start];
while(1)
    [x,y,button] = ginput(1);
    if (button == 3)
        break;
    end
    cntrl_pt = [cntrl_pt; x y];
end
cntrl_pt = [cntrl_pt; p_goal];
n = 100;
dcntrl_pt=diff(cntrl_pt,1,1);
d=sqrt(sum(dcntrl_pt.^2,2));
d=[0; cumsum(d)];
di=linspace(0,d(end),n);
xi=interp1(d,cntrl_pt,di);

%% Cost functions
% Parameters
eta = 2000;
iter = 100;
lambda = 1;
w_obs = 100;

[ A, b, c ] = smooth_matrices( p_start, p_goal, n - 2);
f_smooth = @(xi) cost_smooth( xi, A, b, c);
grad_smooth = @(xi) fsmooth(xi, A, b);  

c_scalar_obs_fn = @(xi) cost_obs( xi, cost_map, p_start );
[ cost_map_x, cost_map_y] = get_cost_map_derivatives( cost_map );
grad_fobs = @(xi) gradient_obs( xi, cost_map, cost_map_x, cost_map_y, p_start );


c_final = @(xi, xi_der) lambda*f_smooth(xi) + w_obs*c_scalar_obs_fn(xi);
grad_final = @(xi, xi_der) lambda*grad_smooth(xi) + w_obs*grad_fobs(xi);

options.eta = eta;
options.max_iter = iter;
options.min_iter = 10;
options.min_cost_improv_frac = 1e-5;
options.M = A;
options.decrease_wt = 1;


[ cost_traversal, time_taken, cost_history, traj_history, h_traj, h_cost] = covariant_gradient_descent( xi, c_final, grad_final, options );


