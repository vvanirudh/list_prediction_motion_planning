function [class_pred,scores] = multi_linear_scorer_predict_regression(features, weights)
% output predicted classes and normalized scores
% class_pred is 1 x N_query
% scores is N_query x L
% features dim x N_query
% weights dim x L

n = size(features,2);
[~, num_classes] = size(weights);

scores = zeros(n,num_classes);

class_pred = zeros(1,n);

for i = 1:n
    f = features(:,i); 
    s = f'*weights;
    s = s-sum(s)/num_classes;
    scores(i,:) = s;
    [~,class_pred(i)] = max(s);
end

end