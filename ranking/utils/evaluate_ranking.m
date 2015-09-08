function err = evaluate_ranking(ranks,qids,ranks_predicted)
% evaluate_ranking(ranks,qids,ranks_predicted)
% evaluate_ranking(ranks,[],ranks_predicted) 
% true ranks derived from values

% case when evaluating single query ranking
if isempty(qids)
    qids = ones(length(ranks),1);
end

unique_qids = unique(qids)';
err = [];
for i = unique_qids
    ranks_i = ranks(qids == i);
    ranks_predicted_i = ranks_predicted(qids == i);
    
    for j = 1:length(ranks_i)
        err = [err; ~ismember(ranks_i((j+1):end), ranks_predicted_i((find( ranks_predicted_i == (ranks_i(j)) )+1):end))];
    end
    
%     corr([ranks_i b],'type','Kendall')
%     err = [err; ranks_i ~= ranks_predicted_i]; %error_between_rankings(ranks_i,ranks_predicted_i);
end
err = mean(err);
end