function [w, obj, wset] = train_linear_primal_sg(features,costs, lambda, surrogate_loss, w0)
%TRAIN_LINEAR_SCORER
% 
% weights = TRAIN_LINEAR_SCORER(features,costs,lambda)
% 
% features - Cell array of length N. features{i} is [L,d]
% costs    - Array of size [N,L]
% lambda   - Regularization constant.
% 
% weights  - Vector of size [d,1]

% with gamma = hinge(1+s)

n = length(features);
dim_features = size(features{1},2);
num_classes = size(features{1},1);

% Wrap up f
f = [];
for i = 1:n
    f_e = features{i};
    f_hat = bsxfun(@minus,f_e,mean(f_e)); % normalize feautures
    f = [f; f_hat];
end

% Wrap up c
c = reshape(costs', [], 1);

%Criterion
if (strcmp(surrogate_loss, 'hinge'))
    g = @(w) c'*hinge_loss(f*w) + 0.5*lambda*w'*w;
    nonsmooth_grad = @(w) hinge_comp_grad(w, f, c);
elseif (strcmp(surrogate_loss, 'square'))
    g = @(w) c'*((1 + f*w).^2) + 0.5*lambda*w'*w;
    nonsmooth_grad = @(w) squared_grad(w, f, c);
else
    error('No surrogate loss specified');
end
    

% g = @(w) c'*abs(1+f*w) + 0.5*lambda*w'*w;
% nonsmooth_grad = @(w) l1_comp_grad(w, f, c);

%  g = @(w) c'*((hinge_loss(f*w)).^2) + 0.5*lambda*w'*w;
%  nonsmooth_grad = @(w) squared_hinge_comp_grad(w, f, c);



num_iter = 1000;
if (nargin <= 4)
    w0 = zeros(dim_features, 1);
end
w = w0;
wset = w;

obj = g(w);
for i = 1:num_iter
    grad = nonsmooth_grad(w) + lambda*w;
    step = 1e-4;%(2e-4)/sqrt(i);
    w = w - step*grad;
    wset = [wset w];
    obj = [obj g(w)];
end

[~,idx] = min(obj);
w = wset(:, idx);

end

function grad = hinge_comp_grad(w, f, c)
v = 1 + f*w;
c(v<=0) = 0;
grad = f'*c;
end


function grad = l1_comp_grad(w, f, c)
v = 1 + f*w;
c = c.*sign(v);
grad = f'*c;
end

function grad = squared_hinge_comp_grad(w, f, c)
v = 1 + f*w;
c(v<=0) = 0;
c = c.*v*2;
grad = f'*c;
end

function grad = squared_grad(w, f, c)
v = 1 + f*w;
c = c.*v*2;
grad = f'*c;
end
