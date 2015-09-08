function viz_compare_seeds(ranks_true,ranks_pred)
hf1 = viz_top_seeds(ranks_true); suptitle('true ranks');
hf2 = viz_top_seeds(ranks_pred); suptitle('pred ranks');

% some fancy positioning for visibility
figpos1 = get(hf1,'Position'); figpos2 = get(hf2,'Position');
figwidth = figpos1(3); figshift = floor(figwidth*0.5+10);
figpos1(1) = figpos1(1)-figshift; figpos2(1) = figpos2(1)+figshift;
set(hf1,'Position',figpos1); set(hf2,'Position',figpos2);
end

