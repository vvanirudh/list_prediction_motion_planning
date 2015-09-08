close all
for set = 1:3
    switch set
        case 1
            rank_data = act_rank_data;
        case 2
            rank_data = orig_rank;
        case 3
            rank_data = cs_ranks_pred;
    end
    figure;
    hold on;
    visualize_cost_map(cost_map);
    for i = 1:3
        idx = rank_data(i);
        traj = library{idx}.traj;
        plot(traj(:,1), traj(:,2), 'LineWidth', 2);
    end
    axis([0 1.15 0 1.15])
    axis off
    saveas(gcf,strcat('seed_',num2str(set),'.fig'));
    saveas(gcf,strcat('seed_',num2str(set),'.eps'));

    
    figure;
    hold on;
    visualize_cost_map(cost_map);
    for i = 1:3
        idx = rank_data(i);
        traj = optim_library{idx}.traj';
        plot(traj(:,1), traj(:,2), 'LineWidth', 2);
    end
    axis([0 1.15 0 1.15])
    axis off
    saveas(gcf,strcat('opt_seed_',num2str(set),'.fig'));
    saveas(gcf,strcat('opt_seed_',num2str(set),'.eps'));
end
