function ranks = ranks_from_values(values,qids)

ranks = [];
for i = unique(qids)'
    values_i = values(qids == i);
    [~,ranks_i] = sort(values_i,'descend');
    ranks = [ranks; ranks_i];
end
end