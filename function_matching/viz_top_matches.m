function hf = viz_top_matches(pp_ref,pps,domain,doi)
hf = figure;
x = linspace(domain(1),domain(2),100);
x = x';

y = ppval(pp_ref,x);
subplot(2,2,1);
plot(x,y); hold on; plot([doi(1) doi(2)],[1 1],'g');
title('ref');
yl = ylim;

% plot 3 ranks
for i = 1:3
    y = ppval(pps(i),x);
    subplot(2,2,i+1);
    plot(x,y); hold on; plot([doi(1) doi(2)],[1 1],'g');
    title(sprintf('rank %d',i));
%     ylim(yl);
end

end

