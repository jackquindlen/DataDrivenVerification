% Authors: Alexandar Kozarev, John Quindlen, Jonathan How, and Ufuk Topcu
% Case Studies in Data-Driven Verification of Dynamical Systems
% January 2016

clear all;
close all;
clc;


%% Load training and testing data
load('wingrock_data.mat');


%% Train the SVM classifier
tic

dpoly = 6;
data1 = dataX( dataY == -1 , 1:2 ); %stable points
data2 = dataX( dataY == 1, 1:2 ); %unstable points
data3 = [data1;data2];

theclass = ones( length(data3) ,1);
theclass(1:length(data1)) = -1;

% Train the SVM Classifier
cl = fitcsvm(data3,theclass,'KernelFunction','rbf',...
    'BoxConstraint',Inf,'ClassNames',[-1,1],...
    'Solver','SMO','Standardize',true,'ScoreTransform','sign',...
    'Cost',[0 1; 10 0]);

[labels1,scores] = predict(cl,data3);
errfrac = sum(labels1 ~= theclass) / size(theclass,1);
disp(['error = ' num2str(errfrac) ' %']);
istabInc = find(theclass == 1 & theclass ~= labels1); % false positive (unsafe errors)
disp(['FP = ' num2str(length(istabInc)) ' of ' num2str(length(find(theclass == 1)))]);
iunstInc = find(theclass == -1 & theclass ~= labels1); % false negative (safe errors)
disp(['FN = ' num2str(length(iunstInc)) ' of ' num2str(length(find(theclass == -1)))]);

%Save the training data
trainingData.istabInc = istabInc;
trainingData.iunstInc = iunstInc;
trainingData.cunstInc = find(theclass == 1 & theclass == labels1);
trainingData.cstabInc = find(theclass == -1 & theclass == labels1);
trainingData.errfrac = errfrac;

toc


%% Test the classifier
tic

[labels1,scores] = predict(cl,xGrid);
errfrac = sum(labels1 ~= labels2) / size(labels2,1);
disp(['error = ' num2str(errfrac) ' %']);
istabInc = find(labels2 == 1 & labels2 ~= labels1); % false positive (unsafe errors)
disp(['FP = ' num2str(length(istabInc)) ' of ' num2str(length(find(labels2 == 1)))]);
iunstInc = find(labels2 == -1 & labels2 ~= labels1); % false negative (safe errors)
disp(['FN = ' num2str(length(iunstInc)) ' of ' num2str(length(find(labels2 == -1)))]);

%Save the testing data
testingData.istabInc = istabInc;
testingData.iunstInc = iunstInc;
testingData.cunstInc = find(labels2 == 1 & labels2 == labels1);
testingData.cstabInc = find(labels2 == -1 & labels2 == labels1);
testingData.errfrac = errfrac;

toc


%% Plot the results
figure; hold
plot(-xGrid(labels2==1 & labels1~=labels2,1),-xGrid(labels2==1 & labels1~=labels2,2),'r.')
plot(-xGrid(labels2==-1 & labels1~=labels2,1),-xGrid(labels2==-1 & labels1~=labels2,2),'b.')
legend('False Positive', 'False Negative');
xlabel('W^*_1');
ylabel('W^*_2');

figure; hold
plot(-xGrid(labels2==1 & labels1==labels2,1),-xGrid(labels2==1 & labels1==labels2,2),'r.')
plot(-xGrid(labels2==-1 & labels1==labels2,1),-xGrid(labels2==-1 & labels1==labels2,2),'b.')
legend('Correct Unstable', 'Correct Stable');
xlabel('W^*_1');
ylabel('W^*_2');

