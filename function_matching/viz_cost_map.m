function hf = viz_cost_map(id)
fname = sprintf('../dataset/env_cost_map_dataset/cost_map_%d.mat',id);
load(fname,'cost_map');
hf = surf(cost_map.table);
set(hf,'lineStyle','none');
title(sprintf('env %d',id));
view([1 1 1.75]);
xlabel('x'); ylabel('y'); zlabel('cost map');
end