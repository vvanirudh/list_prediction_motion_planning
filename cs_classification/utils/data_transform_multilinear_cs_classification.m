function [features,costs] = data_transform_multilinear_cs_classification(data)
% data is in common format}

% features is an array of size d X N
% costs is an array of size N x L

n = length(data);
features = [];

for i = 1:n
    features = [features data(i).contexts'];
    c = data(i).costs';
    c = c-min(c);
    costs(i,:) = c;
    % add bias
end
features = [features; ones(1,n)];

end