function labels_test = nn_library(L,pts_library,pts_test)
% classify based on closest library instance
% pts_library is dim x L
% pts_test is dim x n

D = dist_to_library(L,pts_library,pts_test);
[~,labels_test] = min(D,[],2);
end

