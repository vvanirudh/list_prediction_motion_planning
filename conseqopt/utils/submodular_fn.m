function f = submodular_fn(seed_costs,S,params)
% seed_costs is length L
% S is length K

global_max_cost = params.global_max_cost;
global_min_cost = params.global_min_cost;
threshold = params.threshold;

% dey's version with global limits
%  f = global_max_cost-min(seed_costs(S))/...
% 	 global_max_cost;

% similar to dey, but takes full range [0,1]
% f = (global_max_cost-min(seed_costs(S)))/...
% 	(global_max_cost-global_min_cost);

% with a threshold
f = (global_max_cost-max(threshold,min(seed_costs(S))))/...
	(global_max_cost-threshold);
end