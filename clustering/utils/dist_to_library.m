function D = dist_to_library(L,pts_library,pts_test)
% distance to library instances
% pts_library is dim x L
% pts_test is dim x n
% D is n x L

dim_pts = size(pts_library,1);
% if no transformation
if isempty(L)
    L = eye(dim_pts);
end

pts_library = L*pts_library;
pts_test = L*pts_test;
D = pdist2(pts_test',pts_library');

end

