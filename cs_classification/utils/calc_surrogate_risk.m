function surrogate_risk = calc_surrogate_risk(costs,scores)
% costs is N_test x L
% scores_pred is N_test x L

N_test = size(costs,1);
surrogate_risk = costs.*hinge_loss(scores);
surrogate_risk = sum(surrogate_risk(:))/N_test;
end

