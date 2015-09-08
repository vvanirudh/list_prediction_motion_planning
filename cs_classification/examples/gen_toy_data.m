% From Lee's paper
clear; clc;
% prob1 = @(x) 0.97*exp(-3*x);
% prob3 = @(x) exp(-2.5*(x-1.2).^2);
% prob2 = @(x) 1-prob1(x)-prob3(x);
prob1 = @(x) 0 <= x & x < 1/3;
prob3 = @(x) 2/3 < x;
prob2 = @(x) 1-prob1(x)-prob3(x);

% training
num_train = 100;
num_classes = 3;
features_train = rand(num_train,1);
% features_train = linspace(0,1,num_train)';
features_train = sort(features_train,'ascend');
p1 = prob1(features_train); 
p2 = prob2(features_train);
p3 = prob3(features_train);

p = [p1 p2 p3];
cdfp = cumsum(p,2);
roll = rand(num_train,1);
classes_train = zeros(num_train,1);
costs_train = zeros(num_train,num_classes);
for i = 1:num_train
    classes_train(i) = sum(cdfp(i,:) < roll(i))+1;
    c = ones(1,num_classes);
    c(classes_train(i)) = 0;
    costs_train(i,:) = c;
end

% test
num_test = 100;
features_test = rand(num_test,1);
p1 = prob1(features_test); 
p2 = prob2(features_test);
p3 = prob3(features_test);

p = [p1 p2 p3];
cdfp = cumsum(p,2);
roll = rand(num_test,1);
classes_test = zeros(num_test,1);
costs_test = zeros(num_test,num_classes);
for i = 1:num_test
    classes_test(i) = sum(cdfp(i,:) < roll(i))+1;
    c = ones(1,num_classes);
    c(classes_test(i)) = 0;
    costs_test(i,:) = c;
end

%%
f = cell(1,num_train);
for i = 1:num_train
    f{i} = repmat(features_train(i,:),num_classes,1);
    f{i} = [f{i} ones(num_classes,1)];
end
features_train = f;

f = cell(1,num_test);
for i = 1:num_test
    f{i} = repmat(features_test(i,:),num_classes,1);
    f{i} = [f{i} ones(num_classes,1)];
end
features_test = f;



%%
save('toy_data','features_train','classes_train','costs_train', ...
    'features_test','classes_test','costs_test','num_classes');

%% plot stuff
x = zeros(1,num_train);
for i = 1:num_train
    x(i) = features_train{i}(1,1);
end
figure; plot(x,classes_train,'.');
figure; hist(classes_train);