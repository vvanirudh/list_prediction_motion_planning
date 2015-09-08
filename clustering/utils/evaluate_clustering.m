function err = evaluate_clustering(labels_pred,labels_true)
% 0-1 loss

if ~isrow(labels_pred) labels_pred = labels_pred'; end
if ~isrow(labels_true) labels_true = labels_true'; end

err = sum((labels_pred ~= labels_true))/length(labels_true);
end