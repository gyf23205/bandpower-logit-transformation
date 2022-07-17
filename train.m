clc;
clear;
load("Data.mat");
i=3;
trainRatio = 0.8;
valRatio = 0.2;
testRatio = 0;
[trainInd,valInd,~] = dividerand(Data(i).samples,trainRatio,valRatio,testRatio);
X_train=Data(i).features(:,trainInd);
Y_train=Data(i).label(trainInd);
X_val=Data(i).features(:,valInd);
Y_val=Data(i).label(valInd);
classifiers = cell(4,1);
for j=1:4
    classifiers{j} = fitcdiscr(X_train(j,:).',Y_train);
end
pred = assemble_model(classifiers,X_val.');
acc = sum(Y_val == pred)/length(Y_val);
recall_init = recall(pred,Y_val);
f1_init = f1(acc,recall_init);
% model_set = [beta_model,alpha_model,theta_model,delta_model];


