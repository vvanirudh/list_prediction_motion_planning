function loss = hinge_loss(s)
loss = 1+s;
loss(loss < 0) = 0;
end