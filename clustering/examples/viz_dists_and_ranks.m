function hf = viz_dists_and_ranks(dists,ranks)
% viz as bar plots
% high rank : high bar

hf = figure;
subplot(2,1,1);
bar(1:length(dists),dists);
title('dists');
subplot(2,1,2);
bar(1:length(ranks),length(ranks)-ranks);
title('ranks');
end