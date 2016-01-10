% Authors: Alexandar Kozarev, John Quindlen, Jonathan How, and Ufuk Topcu
% Case Studies in Data-Driven Verification of Dynamical Systems
% January 2016

clear all;
close all;
clc;

%% Load data
load('aircraftSamples2000');
% load('aircraftSamples4000');
% load('aircraftSamples16000');


%% Train SVM classifier:
tic
dpoly = 4; % polynomial kernel order
ss = [1 2 9]; % Variables that define
isafe = find(train_safe);
ifail = find(~train_safe);
dataclass1(isafe) = -1;
dataclass1(ifail) = 1;
trpts = train_points(ss,:)';

% Train the SVM classifier
cl = fitcsvm(trpts,dataclass1','KernelFunction','polynomial',...
    'PolynomialOrder',dpoly,'BoxConstraint',1,'ClassNames',[-1,1],...
    'Solver','SMO','Standardize',true,'ScoreTransform','sign',...
    'Cost',[0 1; 100 0]);
toc

%==========================================================================
% Test the classifier on a set of new points (test points):
tic
isafe = find(test_safe);
ifail = find(~test_safe);
dataclass2(isafe) = -1;
dataclass2(ifail) = 1;
tspts = test_points(ss,:)';
[labels,scores] = predict(cl,tspts);
errfrac = sum(dataclass2' ~= labels) / size(labels,1);
disp(errfrac);
isafeInc = find(dataclass2' == 1 & dataclass2' ~= labels); % false positive
length(isafeInc)
ifailInc = find(dataclass2' == -1 & dataclass2' ~= labels); % false negative
length(ifailInc)
toc

%==========================================================================
% Calculate average k-fold cross-validation:
tic
for ii = 1:10
    M = crossval(cl, 'Kfold', 10);
    L(ii) = kfoldLoss(M);
end
disp(['mean prob error = ' num2str(mean(L))]);
toc

%==========================================================================
% Use the conservative class bounds to classify the test points for comparison:
isafe2 = bounds_class(test_points(1,:),test_points(2,:),test_points(9,:));
isafe = find(isafe2);
ifail = find(~isafe2);
labels(isafe) = -1;
labels(ifail) = 1;
errfrac = sum(labels ~= dataclass2') / size(labels,1);
disp(errfrac);
isafeInc = find(dataclass2' == 1 & dataclass2' ~= labels); % false positive
length(isafeInc)
ifailInc = find(dataclass2' == -1 & dataclass2' ~= labels); % false negative
length(ifailInc)
