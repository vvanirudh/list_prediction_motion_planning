function features = normalize_conseqopt_features(features)
% normalize features across library elements
% features is [1,N] cell.
% features{i} is [L,d]

N = length(features);
for i = 1:N
	f = features{i};
	f = bsxfun(@minus,f,mean(f,1));
	features{i} = f;
end
end