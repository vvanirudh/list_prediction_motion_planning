clear;
L = 10;
domain = [0 10];
num_x = 10;

%%
num_pp = 100;

yls = zeros(num_pp,2);
for i = 1:num_pp
    pp(i) = rand_function(L,domain,num_x);
    hf = plot_pp(pp(i),domain);
    set(hf,'visible','off');
    yls(i,:) = ylim;
    close(hf);
end

yl(1) = median(yls(:,1)); yl(2) = median(yls(:,2));

for i = 1:num_pp
    hf = plot_pp(pp(i),domain);
    fname = sprintf('figs/pp_plots/function_%d.png',i);
    set(hf,'visible','off');
    ylim(yl);
    print('-dpng','-r72',fname);
    close(hf);
end

%%
pps = pp;
save('pp_database','pps','domain','L','num_x');