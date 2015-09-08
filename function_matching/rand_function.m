function [pp,domain] = rand_function(L,domain,num_x)

if nargin < 1
    L = 1;
end
if nargin < 2
    domain = [0 1];
end
if nargin < 3
    num_x = randi(10)+3;
end
x = rand(1,num_x)*(domain(2)-domain(1))+domain(1);
x = sort(x);
y = zeros(1,num_x);

y(1) = rand;
for i = 2:num_x
    dy = (rand*2-1)*L*(x(i)-x(i-1));
    y(i) = y(i-1)+dy;
end

pp = csaps(x,y);
end

