function [max_cost,min_cost] = get_global_cost_limits(data)
% data is in common format

max_cost = 0;
min_cost = Inf;
for i = 1:length(data)
	if max(data(i).costs) > max_cost
		max_cost = max(data(i).costs);
	end
	if min(data(i).costs) < min_cost
		min_cost = min(data(i).costs);
	end
end
end