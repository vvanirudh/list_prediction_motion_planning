%% Avoding a pole using an 
clc
clear
close all

w_obs = 100;

%% Set up obstacle representation
load maps/processed_maps/two_rectangles4.mat;
res = 0.5;
origin = [0 0];

Dint = -bwdist(map);
Dext = bwdist(1-map);

epsilon = 50;
Cint = -res*Dint + 0.5*epsilon;
Cext = (1/(2*epsilon))*((min(res*Dext-epsilon, 0)).^2);
C = Cint + Cext;
[Cy,Cx] = gradient(C./res);

p_start = res*p_set(:,1)';
p_goal =  res*p_set(:,2)'; 

figure;
hold on;
colormap(gray)
imagesc([0 res*size(C,1)], [0 res*size(C,2)], C');
axis xy;
pause;

%% Cost
c = @(x,u) (1 + w_obs*c_dt_squared_cost( x, u, 3, 1, origin, res, C, Cx, Cy, Cxx, Cyy, Cxy))*model.dt;

%% Set up trajectory parameterization
d = 2; %2D config space 
n = 50; %How many waypoints
xi = [linspace(p_start(1),p_goal(1),n+2)' linspace(p_start(2),p_goal(2),n+2)'];
xi(1,:) = [];
xi(end,:) = [];

%% Set up smoothness matrices
% f = 0.5*||Kxi + e||^2
K = zeros(n+1, n);
fd = [-1 1 zeros(1, n-2)];
for i = 1:(n-1)
    K(i+1,:) = circshift(fd, [0 (i-1)]);
end
K(1,1) = 1;
K(n+1,n) = -1;

e = [-p_start; zeros(n-1,2); p_goal];

A = K'*K;
b = K'*e;
c = 0.5*e'*e;

%% Optimization
eta = 50;
iter = 1000;
lambda = 1;
% Visual
traj = [p_start; xi; p_goal];
plot(traj(:,1), traj(:,2));
pause;

for i = 1:iter
    grad1 = fsmooth(xi, A, b);
    grad2 = fobs( xi, n, p_start, C, Cx, Cy, res, origin);
    xi = xi - (1\eta)*A\(lambda*grad1+grad2);
    traj = [p_start; xi; p_goal];
    plot(traj(:,1), traj(:,2));
    %cost_chomp( xi, A, b, c, n, p_start, C, res, origin, lambda)
    i
    pause;
end





