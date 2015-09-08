function [ selected_idx ] = select_seed_ranking(ranks_test,qids_test)
%SELECT_SEED_RANKING 
% test_data is in common format

selected_idx = [];
unique_qids = unique(qids_test)';
for i = unique_qids
    ranks_i = ranks_test(qids_test == i);
    id = ranks_i(1); % ABHIJEEEEEEEEEEEEEEEEEEEEETTTTTTTTTTTTTTTTTTT !!!!!!!!  what were you thinking? :D find(ranks_i == 1);
    selected_idx = [selected_idx; id];
end

end