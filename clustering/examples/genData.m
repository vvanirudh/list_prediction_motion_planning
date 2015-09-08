% number of clusters
nClust = 3;

mus = 5*rand(2,nClust);
nTrainC = 50;
nTrain = nTrainC*nClust;
nTestC = 20;
nTest = nTestC*nClust;

ptsTrain = zeros(2,nTrain);
labelsTrain = zeros(1,nTrain);
ptsTest = zeros(2,nTest);
labelsTest = zeros(1,nTest);

sigma = 0.2*eye(2,2);
for i = 1:nClust
    ptsTrain(:,(i-1)*nTrainC+1:i*nTrainC) = mvnrnd(mus(:,i),sigma,nTrainC)';
    labelsTrain((i-1)*nTrainC+1:i*nTrainC) = i;
    ptsTest(:,(i-1)*nTestC+1:i*nTestC) = mvnrnd(mus(:,i),sigma,nTestC)';
    labelsTest((i-1)*nTestC+1:i*nTestC) = i;
end

ptsTrain0 = ptsTrain;
ptsTest0 = ptsTest;
L = [3 1; 0.2 1];
ptsTrain = L*ptsTrain0;
ptsTest = L*ptsTest0;

%% plot stuff
clc;
figure; axis equal; hold all;
for i = 1:nClust
    ids = labelsTrain == i;
    plot(ptsTrain0(1,ids),ptsTrain0(2,ids),'.');
end
title('original space');
xlabel('x');
ylabel('y');

figure; axis equal; hold all;
for i = 1:nClust
    ids = labelsTrain == i;
    plot(ptsTrain(1,ids),ptsTrain(2,ids),'.');
end
title('transformed space');
xlabel('x');
ylabel('y');

%% save
save('sample_data','ptsTrain0','ptsTest0','labelsTrain','labelsTest','L','ptsTrain','ptsTest');