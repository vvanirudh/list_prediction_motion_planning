function hf = viz_ranks(ranks_1,ranks_2)
% viz ranks as bar plots
% high rank : high bar

hf = figure;
subplot(2,1,1);
bar(1:length(ranks_1),length(ranks_1)-ranks_1);
title('ranks\_1');
subplot(2,1,2);
bar(1:length(ranks_2),length(ranks_2)-ranks_2);
title('ranks\_2');
end