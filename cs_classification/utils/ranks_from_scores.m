function ranks = ranks_from_scores(scores)
% scores is n x num lib

ranks = zeros(size(scores));
for i = 1:size(scores,1)
    [~,ranks(i,:)] = sort(scores(i,:),'descend');
end

end