function [w, obj_vec] = train_multi_linear_subgradient_primal(features,costs,lambda,w0)
%TRAIN_LINEAR_SCORER
% 
% weights = TRAIN_LINEAR_SCORER(features,costs,lambda)
% 
% features - Cell array of length n. features{i} is L x d.
% costs    - Array of size N x L.
% lambda   - Regularization constant.
% 
% w - d x L

% with gamma = hinge(1+s)

% assumes bias has been added to features!

N = length(features);
d = size(features{1},2);
L = size(features{1},1);

for i = 1:N
    for j = 1:L
        F{j}(:,i) = features{i}(j,:)';
    end
end
if (nargin <= 3)
    w0 = zeros(d,L);
end
w = w0;

% assert(check_implementation(),'IMPLEMENTATION CHECK FAILED');

% optimize
w_hist{1} = w;
num_iter = 1e2;
[obj,omega] = calc_objective(w,F,costs,lambda);
obj_vec = obj;
for i = 1:num_iter
    sg = calc_subgrad(w,F,costs,omega,lambda);
    step = 1e-4;
    w = w-step*sg;
    [obj,omega] = calc_objective(w,F,costs,lambda);
    obj_vec = [obj_vec obj];
    w_hist{end+1} = w;
end

[~,min_id] = min(obj_vec);
w = w_hist{min_id};
end

function [obj,omega] = calc_objective(w,F,costs,lambda)
% costs is N x L
L = length(F);
N = size(costs,1);
omega = zeros(size(costs));
u = zeros(L,N);
for j = 1:L
    u(j,:) = w(:,j)'*F{j};
end
mean_u = mean(u,1);
for j = 1:L
    omega(:,j) = 1+u(j,:)-mean_u;
end
omega = hinge_loss(omega);
tmp_mat = costs.*omega;

% adding bias or not?
w_vec = w(1:end-1,:);
w_vec = w_vec(:);
% w_vec = w(:);

obj = sum(tmp_mat(:))+0.5*lambda*norm(w_vec)^2;
end

function [obj,omega] = calc_objective_brute(w,features,costs,lambda)
omega = zeros(size(costs));
[N,L] = size(costs);
obj = 0;
for i = 1:N
    for j = 1:L
        tmp = 1+features{i}(j,:)*w(:,j);
        tmp2 = 0;
        for l = 1:L
            tmp2 = tmp2+features{i}(l,:)*w(:,l);
        end
        tmp = tmp-tmp2/L; tmp = hinge_loss(tmp);
        omega(i,j) = tmp;
        obj = obj+costs(i,j)*tmp;
    end
end

% adding bias or not?
w_vec = w(1:end-1,:);
w_vec = w_vec(:);
% w_vec = w(:);

obj = obj+0.5*lambda*norm(w_vec)^2;
end

function sg = calc_subgrad(w,F,costs,omega,lambda)
% omega is N x L
% w is d x L
% sg is d x L
tmp_mat = costs.*omega;
sg = zeros(size(w));
[d,L] = size(w);
c = reshape(tmp_mat,numel(tmp_mat),1);
for j = 1:L
   sg_j = F{j}*tmp_mat(:,j); 
   G_j = repmat(F{j},1,L);
   sg_j = sg_j-G_j*c/L;
   % take bias into account
   sg_j(1:end-1) = sg_j(1:end-1)+lambda*w(1:end-1,j);
   sg(:,j) = sg_j;
end
end

function sg = calc_subgrad_brute(w,features,costs,omega,lambda)
% omega is N x L
% w is d x L
% sg is d x L

sg = zeros(size(w));
[d,L] = size(w);
[N,L] = size(omega);
for k = 1:L
    sg_k = zeros(d,1);
    for i = 1:N
        sg_k = sg_k+costs(i,k)*omega(i,k)*features{i}(k,:)';
        term = 0;
        for j = 1:L
            term = term+costs(i,j)*omega(i,j)*features{i}(k,:)';
        end
        sg_k = sg_k-term/L;
    end
    sg_k(1:end-1) = sg_k(1:end-1)+lambda*w(1:end-1,k);
    sg(:,k) = sg_k;
end
end

function res = check_implementation()
% check calculation of objective and subgrad
w = rand(d,L);
[obj1,omega1] = calc_objective(w,F,costs,lambda);
[obj2,omega2] = calc_objective_brute(w,features,costs,lambda);
res1 = isequal(obj1,obj2);
sg1 = calc_subgrad(w,F,costs,omega1,lambda);
sg2 = calc_subgrad_brute(w,features,costs,omega2,lambda);
res2 = isqeual(sg1,sg2);
res = res1 && res2;
end








