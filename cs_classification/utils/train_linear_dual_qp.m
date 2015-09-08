function [A, b, lb, ub, F_hat] = train_linear_dual_qp(features,costs,lambda)
% features is a cell array of length num instances. features{i} is an array of size 
% num lib x dim features
% costs is an array of size num instances x num lib
% lambda is regularization

[N,L] = size(costs);
dim_features = size(features{1},2);
F_hat = zeros(dim_features,N*L);

for i = 1:N
    f_e = features{i};
    f_hat = bsxfun(@minus,f_e,mean(f_e)); % normalize feautures
    F_hat(:,((i-1)*L+1):i*L) = f_hat';
end


% min 0.5*alpha'*Q*alpha+r'*alpha
% st 0 < alpha < C
Q = F_hat'*F_hat/lambda;
% TODO: kernelize
% Q = pdist2(F_hat',F_hat',@(x,y) kernelRBF(x,y,kernelParams))/lambda;
r = -ones(N*L,1);
C = reshape(costs', [],1);

A = Q;
b = r;
lb = zeros(size(C));
ub = C;
end