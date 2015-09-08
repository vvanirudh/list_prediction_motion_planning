function [w, obj, wset] = train_multi_linear_square(features,losses,lambda)
%TRAIN_LINEAR_SCORER
% 
% weights = TRAIN_LINEAR_SCORER(features,losses,lambda)
% 
% features - Array size [d,N]
% losses    - Array of size [N,L]
% lambda   - Regularization constant.
% 
% weights  - Vector of size [dL,1]

[N,L] = size(losses);
d = size(features,1);

% some helper matrices

% F{j} is simply the features in block j
% F{j} is [d*L,N]
F = cell(1,L);
for j = 1:L
    F_j = zeros(d*L,N);
    ids = (j-1)*d+1:j*d;
    F_j(ids,:) = features;
    F{j} = F_j;
end

% L{j} is diag([losses(1,j) ... losses(n,j)])
% L{j} is [N,N]
L = cell(1,L);
for j = 1:L
    L{j} = diag(losses(:,j));
end
% L_mean is averaged version
% L_mean is [N,N]
L_mean = diag(mean(losses,2));


% I{j,k} picks out jth weight and puts it in block k
% I{j,k} is [d*L,d*L]
I = cell(L,L);
for j = 1:L
    ids_col = (j-1)*d+1:j*d;
    for k = 1:L
        ids_row = (k-1)*d+1:k*d;
        I_jk = zeros(d*L,d*L);
        I_jk(ids_row,ids_col) = eye(d,d);
        I{j,k} = I_jk;
    end
end

% A{j} calculates the mean weight and puts it in block j
% A{j} is [d*L,d*L]
A = cell(1,L);
averager_row = zeros(1,d*L);
ids = [0:L-1]*d+1;
averager_row(ids) = 1/L;
averager_matrix = zeros(d,d*L);
for j = 1:L
    averager_matrix(j,:) = circshift(averager_row,[0,j-1]);
end
for j = 1:L
    ids = (j-1)*d+1:j*d;
    A_j = zeros(d*L,d*L);
    A_j(ids,:) = averager_matrix;
    A{j} = A_j;
end

% going to solve
% Cw = d
% but will assemble C and d in steps
C = zeros(d*L,d*L);
d = zeros(d*L,1);
for j = 1:L
    ids = (j-1)*d+1;J*d;
    
    mat1 = (F{j}*L{j})'*(I{j,j}-A{j});
    mat2 = zeros(d*L,d*L);
    for k = 1:L
        mat2 = mat2+(F{j}*L{k})'*(I{k,j}-A{j});
    end
    mat2 = mat2/L;
    mat3 = lambda*I{j};
    C_j = mat1-mat2+mat3;
    C(ids,:) = C_j(ids,:);
    
    d_j = -F{j}*(L{j}-L_mean);
    d(ids) = d_j(ids);
end

% finally
w = C\d;
end

