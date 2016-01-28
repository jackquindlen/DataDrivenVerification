% Authors: Alexandar Kozarev, John Quindlen, Jonathan How, and Ufuk Topcu
% Case Studies in Data-Driven Verification of Dynamical Systems
% January 2016

clear all;
close all;
clc;


%% Load training and testing data
load('acrobot_data.mat'); %training and testing data
% train_data: training data (4000x4)
% train_class: correct labels to the data (1x4000)
% test_data: testing data (4000x4)
% test_class: correct labels (1x4000)


%% Train the SVM classifier
tic

% Train the SVM classifier
cl = fitcsvm(train_data,train_class','KernelFunction','polynomial',...
    'PolynomialOrder',4,'BoxConstraint',1,'ClassNames',[-1,1],...
    'Solver','SMO','Standardize',true,'ScoreTransform','sign',...
    'Cost',[0 1; 100 0]);
disp('------------------------------------------------------------------');

% Test on the training data
disp('Testing on training data:');
[labels,scores1] = predict(cl,train_data);
errfrac = sum(train_class' ~= labels) / size(labels,1);
disp(['error = ' num2str(errfrac * 100) ' %']);
isafeInc = find(train_class' == 1 & train_class' ~= labels); % false positive
disp(['FP = ' num2str(length(isafeInc)) ' of ' num2str(length(find(train_class' == 1)))]);
ifailInc = find(train_class' == -1 & train_class' ~= labels); % false negative
disp(['FN = ' num2str(length(ifailInc)) ' of ' num2str(length(find(train_class' == -1)))]);
toc


%% Test classifier on testing data
tic
disp('------------------------------------------------------------------');
disp('Empirical testing:');
[labels,scores] = predict(cl,test_data);
errfrac = sum(test_class' ~= labels) / size(labels,1);
disp(['error = ' num2str(errfrac * 100) ' %']);
isafeInc = find(test_class' == 1 & test_class' ~= labels); % false positive
disp(['FP = ' num2str(length(isafeInc)) ' of ' num2str(length(find(test_class' == 1)))]);
ifailInc = find(test_class' == -1 & test_class' ~= labels); % false negative
disp(['FN = ' num2str(length(ifailInc)) ' of ' num2str(length(find(test_class' == -1)))]);
toc


%% Estimate generalization error w/ cross-validation
tic
for ii = 1:10
    M = crossval(cl, 'Kfold', 10);
    L(ii) = kfoldLoss(M);
end
disp('------------------------------------------------------------------');
disp('K-fold cross-validation testing:');
disp(['Generalization error = ' num2str(mean(L))]);
toc