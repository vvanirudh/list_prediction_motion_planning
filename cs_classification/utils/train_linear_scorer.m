function weights = train_linear_scorer(features,costs,lambda)
%TRAIN_LINEAR_SCORER
% 
% weights = TRAIN_LINEAR_SCORER(features,costs,lambda)
% 
% features - Cell array of length n. features{i} is num lib x dim features
% costs    - Array of size n x num lib.
% lambda   - Regularization constant.
% 
% weights  - Vector of size dim features x 1.

% with gamma = (1+s)^2
n = length(features);
dim_features = size(features{1},2);
num_classes = size(features{1},1);
b = zeros(dim_features,1);
A = zeros(dim_features,dim_features);
for i = 1:n
    f = features{i}; f = f';
    f = bsxfun(@minus,f,sum(f,2)/num_classes); % normalize feautures
    c = costs(i,:); c = c';
    b = b-2*f*c;
    fc = bsxfun(@times,f,c');
    A = A+2*fc*f';
end

A = A+lambda*eye(dim_features);
weights = A\b;
end

