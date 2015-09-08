function model = train_mcsvm(features,costs,varargin)
% model = TRAIN_MCSVM(features,costs)
% model = TRAIN_MCSVM(features,costs,lambda)
% model = TRAIN_MCSVM(features,costs,lambda,bw)
% features is num_instances x dim_features
% costs is num_instances x num_classes
% lambda is regularization constant

% default parameters
if nargin == 2
   lambda = 1;
   kernelParams.h = 1;
end
if nargin > 2
    lambda = varargin{1};
end
if nargin > 3
    kernelParams.h = varargin{2};
end

num_instances = size(features,1); 
num_classes = size(costs,2);
classes = classes_from_values(1-costs);
I = eye(num_classes);
J = ones(num_classes);
K = pdist2(features,features,@(x,y) kernelRBF(x,y,kernelParams));
eigK = eig(K);
M = hinge_coeff_matrix(classes,num_classes);
Y = reshape(M,numel(M),1); % Y in 4.41 of Lee
num_alpha = length(Y);
e = ones(num_instances,1);

% inputs to quadprog
problem.H = kron(I-J/num_classes,K);
problem.f = num_instances*lambda*Y;
problem.lb = 0*ones(num_alpha,1);
problem.ub = reshape(costs,numel(costs),1);
problem.Aeq = kron(I-J/num_classes,e)';
problem.beq = 0*ones(num_classes,1);
problem.solver = 'quadprog';
problem.options = optimoptions('quadprog','Algorithm','interior-point-convex','Display','off');

alphaStack = quadprog(problem);

% get primal from dual
alphaMat = reshape(alphaStack,num_instances,num_classes);
colsum = sum(alphaMat,2)/num_classes;
% cMat is num_classes x num_instances
cMat = bsxfun(@minus,alphaMat,colsum); cMat = -cMat/(num_instances*lambda);
b = zeros(num_classes,1);
% get bias terms
for j = 1:num_classes
    flag = (0 < alphaMat(:,j)) & (alphaMat(:,j) < costs(:,j));
    instances_id = find(flag); 
    if isempty(instances_id)
        error('HOW ELSE DO I CALCULATE B FROM DUAL?');
    end
    id = instances_id(1);
    b(j) = M(id,j)-dot(K(:,id),cMat(:,j));
end

% construct model
model.num_classes = num_classes;
model.features = features;
model.cMat = cMat;
model.b = b;
model.kernel = @kernelRBF;
model.kernelParams = kernelParams;
end

function M = hinge_coeff_matrix(y,num_classes)
% y is a vector of classes
% M is the matrix with ith row y_i as in 4.4 of Lee

n = length(y);
M = zeros(n,num_classes);
for i = 1:n
    M(i,y(i)) = 1;
    rest = setdiff(1:num_classes,y(i));
    M(i,rest) = -1/(num_classes-1);
end

end