function [X,y] = conseqopt_data_transform_weighted_regression(features,C)
% features is cell array length N. features{i} is [L,d]
% C is [N,L]
% X is [L*N,d]
% y = [L*N,1];

[N,L] = size(C);
y = reshape(C',L*N,1);
d = size(features{1},2);
X = zeros(L*N,d);

for i = 1:N
	f = features{i};
	% center features
	f = bsxfun(@minus,f,mean(f,1));
	X((i-1)*L+1:i*L,:) = f;
end

end