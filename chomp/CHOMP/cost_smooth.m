function [ cost_traj ] = cost_smooth( xi, A, b, c)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

cost_traj = (size(xi,1)+1)*trace(0.5*xi'*A*xi + xi'*b + c);

end

