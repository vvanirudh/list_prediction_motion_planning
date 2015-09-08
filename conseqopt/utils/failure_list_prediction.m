function [failure] = failure_list_prediction( test_data, S, fail_thresh)
%EVALUATE_PREDICTION Summary of this function goes here
%   Detailed explanation goes here

[N,B] = size(S);
failure = [];
for level = 1:B
    num_failures = 0;
    for i = 1:length(test_data)
        min_list_cost = min(test_data(i).costs(S(i,1:level)));
        if (min_list_cost > fail_thresh)
            num_failures = num_failures + 1;
        end
    end
    failure = [failure num_failures/length(test_data)];
end

end

