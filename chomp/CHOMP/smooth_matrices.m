function [ A, b, c ] = smooth_matrices( p_start, p_goal, n )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%% Set up smoothness matrices
% f = 0.5*||Kxi + e||^2
K = zeros(n+1, n);
fd = [-1 1 zeros(1, n-2)];
for i = 1:(n-1)
    K(i+1,:) = circshift(fd, [0 (i-1)]);
end
K(1,1) = 1;
K(n+1,n) = -1;

e = [-p_start; zeros(n-1, length(p_start)); p_goal];

A = K'*K;
b = K'*e;
c = 0.5*(e'*e);

end

