%% Squared cost function should be consistent independent of resolution. 
% Resolution factors in because different algorithms need the notion of a 
% cost map as opposed to a function. 

clc
clear
close all

%% Create original cost function
eps = 0.3;
p_obs = [0.4 0.5];
c_obs = @(x,y) (0.5/eps)*min(sqrt((x-p_obs(1)).^2 + (y-p_obs(2)).^2) - eps, 0).^2; %x and y \in [0,1]

%% Check for resolution 
res = 1000;
[X, Y] = meshgrid(1:res);
X = X/res;
Y = Y/res; % now X and Y are \in [0,1]

C1 = c_obs(X,Y);
% Visualize
figure;
imagesc(C1);
colormap(gray);
axis xy;
hold on;
plot([100 900], [300 300]);

%% Now we will create the same with DT. It wont be pretty but it will do!
BW = zeros(res,res);
BW(round(res*p_obs(1)), round(res*p_obs(2))) = 1; 
D = bwdist(BW);
C2 = (1/(2*eps))*((min(D/res-eps, 0)).^2);
% Visualize
figure;
imagesc(C2');
colormap(gray);
axis xy;
hold on;
plot([100 900], [300 300]);