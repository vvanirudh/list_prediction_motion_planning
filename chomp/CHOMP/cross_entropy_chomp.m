function [glob_opt_traj, glob_opt_cost, evaluate_epoch, traj_epoch]  = cross_entropy_chomp( p_start, p_goal, n, ce_options, chomp_fn )

v2struct(ce_options);
xi_orig = transpose(linspaceNDim(p_start, p_goal, n_sparse+2));
xi_orig(1,:) = [];
xi_orig(end,:) = [];
perp = normr((p_start - p_goal)*[0 -1; 1 0]);

evaluate_epoch = [];
traj_epoch = [];
fprintf('CE progress ');
for epochs = 1:max_epochs
    fprintf(' %f ', 100*epochs/max_epochs);
    performance = cell(N_samples, 2);
    for i = 1:N_samples
        weight = mvnrnd(param_mu, param_sigma);
        cntrl_pt = xi_orig + bsxfun(@times, perp, weight');
        cntrl_pt = [p_start; cntrl_pt; p_goal];
        dcntrl_pt=diff(cntrl_pt,1,1);
        d=sqrt(sum(dcntrl_pt.^2,2));
        d=[0; cumsum(d)];
        di=linspace(0,d(end),n);
        xi=interp1(d,cntrl_pt,di);
        
        [ ~,~, cost_history, ~] = chomp_fn(xi);
        performance{i, 1} = min(cost_history);
        performance{i, 2} = weight;
    end

    performance = sortrows(performance,1);
    candidates = [];
    for i = 1:ceil(rho*N_samples)
        candidates = [candidates; performance{i, 2}];
    end

    param_mu = mean(candidates);
    param_sigma = cov(candidates);
    if (trace(param_sigma)/size(param_sigma,1) < sigma_inject)
        break;
    end
    param_sigma = param_sigma + sigma_inject*sqrt(1/epochs)*eye(size(param_sigma));
    
    cntrl_pt = xi_orig + bsxfun(@times, perp, param_mu');
    cntrl_pt = [p_start; cntrl_pt; p_goal];
    dcntrl_pt=diff(cntrl_pt,1,1);
    d=sqrt(sum(dcntrl_pt.^2,2));
    d=[0; cumsum(d)];
    di=linspace(0,d(end),n);
    xi=interp1(d,cntrl_pt,di);

    [ ~,~, cost_history,  traj_history] = chomp_fn(xi);
    [M,I] = min(cost_history);
    
    evaluate_epoch = [evaluate_epoch; M];
    traj_epoch = [traj_epoch; traj_history(I)];
end
fprintf('\n');
[V,I] = min(evaluate_epoch);
glob_opt_traj = traj_epoch(I);
glob_opt_cost = V;
end

