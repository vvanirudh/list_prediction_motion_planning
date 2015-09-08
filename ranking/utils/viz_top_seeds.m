function hf = viz_top_seeds(ranks)

hf = figure;
for i = 1:4
    fname = sprintf('../../dataset/solution_env_figs/solution_env_%d.png',ranks(i));
    im{i} = imread(fname);
    subplot(2,2,i); imshow(im{i}); title(['rank ' num2str(i) ', seed ' num2str(ranks(i))]);
end
end

