function true_risk = calc_true_risk(costs,class_pred)
% costs is N_test x L
% class_pred is length N_test

N_test = size(costs,1);
true_risk = 0;
for i = 1:N_test
    true_risk = true_risk+costs(i,class_pred(i));
end
true_risk = true_risk/N_test;
end

