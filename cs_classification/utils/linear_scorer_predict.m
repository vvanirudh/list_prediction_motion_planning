function [class_pred,scores] = linear_scorer_predict(features, weights)
% output predicted classes and normalized scores
% class_pred is 1 x N_query
% scores is N_query x L

n = length(features);
num_classes = size(features{1},1);
scores = zeros(n,num_classes);
class_pred = zeros(1,n);
for i = 1:n
    f = features{i}; 
    s = f*weights;
    s = s-sum(s)/num_classes;
    scores(i,:) = s';
    [~,class_pred(i)] = max(s);
end
end