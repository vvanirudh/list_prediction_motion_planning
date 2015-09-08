function hf = plot_pp(pp,domain)
hf = figure;
x = linspace(domain(1),domain(2),100);
y = ppval(pp,x);
plot(x,y);
end

