function [ cost_traversal, time_taken, cost_history, traj_history, h_traj, h_cost ] = covariant_gradient_descent( xi, cost_fn, grad_fn, options )
%COVARIANT_GRADIENT_DESCENT Summary of this function goes here
%   Detailed explanation goes here

p_start = xi(1,:);
p_goal = xi(end,:);

xi(1,:) = [];
xi(end,:) = [];

%% Optimization
eta = options.eta;
max_iter = options.max_iter;
min_iter = options.min_iter;
M = options.M;

cost_history = [];
traj_history = [];

n = size(xi,1) + 1;
xi_der = n*diff([p_start; xi]);

traj.x = [p_start; xi; p_goal]';
traj_history = [traj_history; traj];
cost_history = [cost_history; cost_fn(xi, xi_der)];

tic
for i = 1:max_iter
    n = size(xi,1) + 1;
    xi_der = n*diff([p_start; xi]);
    
    grad = grad_fn(xi, xi_der);
    if (options.decrease_wt == 1)
        step_size = (1/eta)*(1/sqrt(i));
    else
        step_size = (1/eta);
    end
    
    xi = xi - step_size*(M\(grad));
    n = size(xi,1) + 1;
    xi_der = n*diff([p_start; xi]);
    
    traj.x = [p_start; xi; p_goal]';
    traj_history = [traj_history; traj];
    cost_history = [cost_history; cost_fn(xi, xi_der)];
    
    if (i > min_iter)
        if ((cost_history(i) - cost_history(i+1)) > 0 && (cost_history(i) - cost_history(i+1))/cost_history(i) < options.min_cost_improv_frac)
            break;
        end
    end
end
time_taken = toc;
cost_traversal = cost_history(end);

if (nargout > 4)
    figure(1);
    hold on;
    cc=hsv(size(traj_history,1));
    for i = 1:size(traj_history,1)
        plot(traj_history(i).x(1,:), traj_history(i).x(2,:),'color',cc(i,:))
        %plot(traj_history(i).x(1,:), -traj_history(i).x(3,:),'color',cc(i,:))
    end
    h_traj = gcf;

    figure(2);
    plot(cost_history);
    h_cost = gcf;
end

end




