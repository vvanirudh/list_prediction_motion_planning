function err = error_between_rankings(ranks_1,ranks_2)
% hacky error metric between rankings
% this is a symmetric mesaure

n_ranks = length(ranks_1);
weights = 1./(1:n_ranks+1); % care about higher ranks more
weights = weights/sum(weights);
err = 0;
for i = 1:n_ranks
    pos_true = find(ranks_1 == i);
    pos_pred = find(ranks_2 == i);
    err = err+weights(i)*abs(pos_true-pos_pred);
end

end

