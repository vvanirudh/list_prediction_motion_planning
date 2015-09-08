function ids = get_unsolvable_envs(data,fail_thresh)
% return ids which are unsolvable
% data is in common format

ids = [];
for i = 1:length(data)
	if min(data(i).costs) > fail_thresh
		ids = [ids i];
	end
end

end