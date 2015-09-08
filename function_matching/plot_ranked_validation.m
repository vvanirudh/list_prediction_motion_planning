% save plots of ranked validation rkfits
% requires presence of some variables in workspace

yl = [-20 20];
domain = [0 10];
hf = plot_rkfit(rkfit_lib(lib_id),domain);
set(hf,'visible','off');
ylim(yl); 
xlim(domain);
hold on; plot(doi(lib_id,:),[1 1],'g');
fname = sprintf('figs/validation_ranks/ref');
print(hf,'-dpng','-r72',fname);
close(hf);
    
for i = 1:length(ranks)
    hf = plot_rkfit(rkfit_validation(ranks(i)),domain);
    set(hf,'visible','off');
    ylim(yl);
    xlim(domain);
    hold on; plot(doi(lib_id,:),[1 1],'g');
    fname = sprintf('figs/validation_ranks/rank_%d',i);
    print(hf,'-dpng','-r72',fname);
    close(hf);
end