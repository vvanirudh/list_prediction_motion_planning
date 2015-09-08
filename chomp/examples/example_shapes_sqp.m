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
xi(1,:) = [];
xi(end,:) = [];
%% Set up trajectory parameterization
% n = 100; %How many waypoints
% xi = [linspace(p_start(1),p_goal(1),n)' linspace(p_start(2),p_goal(2),n)'];
pt_con_fn = @(pt) -100*distance_pt_shapes( pt, shapes_array );
pt_con_grad_fn = @(pt) -100*grad_pt_shapes( pt, shapes_array );
constraint_fn = @(x) fmincon_constraint_shapes(x, @(x)deal(stacked_fn( reshape(x, [], 2), pt_con_fn )), @(x) grad_shapes( x, pt_con_grad_fn ));
criterion_fn = @(x)  fmincon_cost( x, p_start, p_goal );%1000000*sum(sum(diff([p_start; reshape(x, [], 2); p_goal]).^2));%10000*sum(sum(diff([p_start; reshape(x, [], 2); p_goal]).^2));     %10000*trace(trace(diff(reshape(x, [], 2))*diff(reshape(x, [], 2))')) ;%sum(sqrt(sum(diff(reshape(x, [], 2)).^2,2)));


%% Parameter vector
x0 = reshape(xi, 1, []);

% set options for fmincon()
options = optimset('MaxFunEvals',1000000,'Display','iter', 'TolFun', 1e-2, 'MaxIter', 100, 'GradObj','on', 'GradConstr','on', 'Algorithm', 'interior-point', 'TolX', 0);

%% do optimization
[x,fval,exitflag]=fmincon(criterion_fn, x0, [],[],[],[],-1, 1, constraint_fn, options);