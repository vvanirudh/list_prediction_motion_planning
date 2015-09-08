function val = stacked_fn( xi, fn )
%STACKED_FN Summary of this function goes here
%   Detailed explanation goes here

val = [];
for t = 1:size(xi,1)
    val = [val; fn(xi(t,:))];
end

end

