clear; clc;
load pp_database

%%
ref_id = 1;
others = setdiff(1:length(pps),ref_id);

for i = 1:length(others)
    scores(i) = pdist(pps(ref_id).coefs,pps(others(i)).coefs,'cosine');
end
[~,ranks] = sort(scores,'ascend');

%%
yl = [-20 20];
hf = plot_pp(pp_lib(lib_id),domain);
set(hf,'visible','off');
ylim(yl); 
xlim(domain);
hold on; plot(doi(lib_id,:),[1 1],'g');
fname = sprintf('figs/brute_matching/ref');
print(hf,'-dpng','-r72',fname);
close(hf);
    
for i = 1:length(ranks)
    hf = plot_pp(pp_validation(ranks(i)),domain);
    set(hf,'visible','off');
    ylim(yl);
    xlim(domain);
    hold on; plot(doi(lib_id,:),[1 1],'g');
    fname = sprintf('figs/brute_matching/rank_%d',i);
    print(hf,'-dpng','-r72',fname);
    close(hf);
end


