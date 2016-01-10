% Authors: Alexandar Kozarev, John Quindlen, Jonathan How, and Ufuk Topcu
% Case Studies in Data-Driven Verification of Dynamical Systems
% January 2016

clear all;
close all;
clc;


%% Load training and  testing data
load('vdp_data.mat'); %both training and testing data


%% Train the SVM Classifier
tic

% Setup training data
data1 = dataX( dataY == -1 , : );
data2 = dataX( dataY == 1, : );
data3 = [data1;data2];
theclass = ones( length(data3) ,1);
theclass(1:length(data1)) = -1;

dpoly = 4; % polynomial kernel order

% Train the SVM Classifier
cl = fitcsvm(data3,theclass,'KernelFunction','polynomial',...
    'PolynomialOrder',dpoly,'BoxConstraint',10,'ClassNames',[-1,1],...
    'Solver','SMO','Standardize',true,'ScoreTransform','sign',...
    'Cost',[0 1; 1 0]);

disp('------------------------------------------------------------------');

%Test on the training data
disp('Testing on training data:');
[labels1,scores] = predict(cl,data3);
errfrac = sum(labels1 ~= theclass) / size(theclass,1);
disp(['error = ' num2str(errfrac) ' %']);
istabInc = find(theclass == 1 & theclass ~= labels1); % false positive
disp(['FP = ' num2str(length(istabInc)) ' of ' num2str(length(find(theclass == 1)))]);
iunstInc = find(theclass == -1 & theclass ~= labels1); % false negative
disp(['FN = ' num2str(length(iunstInc)) ' of ' num2str(length(find(theclass == -1)))]);
toc

% Generalization error
tic
for ii = 1:100
    M = crossval(cl, 'Kfold', 10);
    L(ii) = kfoldLoss(M);
end
disp('------------------------------------------------------------------');
disp(['Generalization error = ' num2str(mean(L))]);
toc


%% Predict scores over the testing grid
tic
disp('------------------------------------------------------------------');
disp('Empirical testing:');
[labels1,scores] = predict(cl,xGrid);
errfrac = sum(labels1 ~= xGridLabels) / size(xGridLabels,1);
disp(['error = ' num2str(errfrac) ' %']);
istabInc = find(xGridLabels == 1 & xGridLabels ~= labels1); % false positive
disp(['FP = ' num2str(length(istabInc)) ' of ' num2str(length(find(xGridLabels == 1)))]);
iunstInc = find(xGridLabels == -1 & xGridLabels ~= labels1); % false negative
disp(['FN = ' num2str(length(iunstInc)) ' of ' num2str(length(find(xGridLabels == -1)))]);
toc


%% Plot test results:
figure; hold on;
plot(xGrid(xGridLabels==1 & labels1~=xGridLabels,1),xGrid(xGridLabels==1 & labels1~=xGridLabels,2),'r.')
plot(xGrid(xGridLabels==-1 & labels1~=xGridLabels,1),xGrid(xGridLabels==-1 & labels1~=xGridLabels,2),'b.')
legend('False Positive', 'False Negative');
hold off;
figure; hold on;
plot(xGrid(xGridLabels==1 & labels1==xGridLabels,1),xGrid(xGridLabels==1 & labels1==xGridLabels,2),'b.')
plot(xGrid(xGridLabels==-1 & labels1==xGridLabels,1),xGrid(xGridLabels==-1 & labels1==xGridLabels,2),'r.')
legend('Correct Unstable', 'Correct Stable');
hold off;

% Plot the data and the decision boundary:
figure; hold on;
h(1:2) = gscatter(data3(:,1),data3(:,2),theclass,'rb','.',16);
h(3) = plot(data3(cl.IsSupportVector,1),data3(cl.IsSupportVector,2),'ko');
contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k');
legend(h,{'Stab','Unstab','Support Vectors'});
xlim([-3 3]);
ylim([-3 3]);
xlabel('x_1');
ylabel('x_2');
hold off;

% Plot the decision boundary along with the true limit cycle:
figure; hold on;
set(gcf,'renderer','zbuffer');
[CC HH] = contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'--k');
set(HH,'LineWidth',3)
vdp1 = @(t,z) [z(2), (1 - z(1)^2)*z(2) - z(1)]';
[T,Z] = ode45(vdp1,[0 20],[2 0]);
plot(Z(:,1),Z(:,2),'r.')
title(['SVM Classification: Polynomial kernel degree ' num2str(dpoly)]);
xlabel('x_1');
ylabel('x_2');
hold off;
