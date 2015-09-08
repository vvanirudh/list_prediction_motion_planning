
[values_test,features_test,qids_test] = data_transform_ranking(validation_data,'query');
ranks_test = ranks_from_values(values_test,qids_test);
D = dist_to_library(L,pts_library,pts_test);

%%
close all;
id = 1;
dists = D(id,:);
ranks_pred = distances_to_ranks(dists);
ranks = ranks_test(qids_test == id);
viz_dists_and_ranks(dists,ranks);
viz_compare_seeds(ranks,ranks_pred);

