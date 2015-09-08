function weights = train_multi_linear_dual_qp(features,costs,lambda)
% features is a cell array of length num instances. features{i} is an array of size 
% num lib x dim features
% costs is an array of size num instances x num lib
% lambda is regularization
% weights is dim features x num lib

[N,L] = size(costs);
dim_features = size(features{1},2);
F = cell(1,L);
G = cell(1,L);

for j = 1:L
    F{j} = zeros(dim_features,N);
    for i = 1:N
        F{j}(:,i) = features{i}(j,:)';
    end
    G{j} = [zeros((j-1)*L,dim_features) F{j} zeros((L-j)*L,dim_features)] - ...
        repmat(F{j},1,L)/L;
end

% min 0.5*alpha'*Q*alpha+r'*alpha
% st 0 < alpha < C
Q = zeros(N*L,N*L);
for j = 1:L
    Q = Q+G{j}'*G{j};
end
Q = Q/lambda;
% TODO: kernelize
r = -ones(1,N*L);
C = reshape(costs,numel(costs),1);
% TODO: oracle solves QP
alpha = zeros(N*L,1);

% primal solution from dual
v = zeros(dim_features,L);
for j = 1:L
    v(:,j) = G{j}*alpha;
end
weights = -v/lambda;
end