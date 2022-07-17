clc;
clear;
load("Data.mat");
%% Data split
a=1;
b=4;
% ratio_init = 0.1;
class_num = 5;
ratio_increase = 0.2;
num_new = Data(b).samples;
acc_hist = [];
recall_hist = [];
f1_hist = [];
ratio_val = 0.2;
idx = randperm(Data(a).samples);
X_init_train = Data(a).features(:,idx);
Y_init_train = Data(a).label(:,idx);
retrain_times = int32((1-ratio_val)/ratio_increase);
idx = randperm(Data(b).samples);
data_all_new = Data(b).features(:,idx);
label_all_new = Data(b).label(:,idx);
X_val = data_all_new(:,int32((1-ratio_val)*num_new)+1:end);
Y_val = label_all_new(int32((1-ratio_val)*num_new)+1:end);
% X_val = Data(i+1).features;
% Y_val = Data(i+1).label;
%% Init train
% Classifiers
classifiers = cell(4,1);
for j=1:4
    classifiers{j} = fitcdiscr(X_init_train(j,:).',Y_init_train);
end
pred = assemble_model(classifiers,X_val.');
% History
acc_init = sum(Y_val == pred)/length(Y_val);
acc_hist = [acc_hist, acc_init];
recall_init = recall(pred, Y_val);
recall_hist = [recall_hist,recall_init];
f1_init = f1(acc_init, recall_init);
f1_hist = [f1_hist, f1_init];
%% Init cluster
S.mu = zeros(class_num,size(X_init_train,1));
for j = 1:class_num
    temp = Y_init_train == (j-1);
    S.mu(j,:) = mean(X_init_train(:,temp),2);
end
S.Sigma = zeros(size(X_init_train,1),class_num);
for j = 1:class_num
    temp = Y_init_train == (j-1);
    S.Sigma(:, j) = var(X_init_train(:,temp),0,2);
end
S.ComponentProportion = zeros(1,class_num);
for j = 1:class_num
    temp = Y_init_train == (j-1);
    S.ComponentProportion(j) = sum(temp)/size(X_init_train,2);
end
clusters = cell(4,1);
for j=1:4
    s.mu = S.mu(:,j);
    s.Sigma = zeros(1,1,class_num);
    s.Sigma(1,1,:) = S.Sigma(j,:);
    s.ComponentProportion = S.ComponentProportion;
    clusters{j}=fitgmdist(X_init_train(j,:).',class_num,"Start",s); 
%     clusters{j}=fitgmdist(X_init_train(j,:).',class_num);
end
%% Retrain loop
acc_pseudo_hist = [];
recall_pseudo_hist = [];
f1_pseudo_hist = [];
X_retrain = X_init_train(:,1:500);
Y_retrain = Y_init_train(1:500);
% Get pseudo label
for j=1:retrain_times
    idx_start = int32(num_new*(double((j-1))*ratio_increase)+1);
    idx_end = int32(num_new*(double(j)*ratio_increase));
    X_new = data_all_new(:,idx_start:idx_end);
    Y_true = label_all_new(idx_start:idx_end);
    label_cluster = zeros(4, idx_end-idx_start+1);
    label_class = assemble_model(classifiers, X_new.');
    for k =1:4
        label_cluster(k,:) = cluster(clusters{k},X_new(k,:).').'-1;
        label_cluster(k,:) = relabel(label_cluster(k,:), label_class,class_num);
    end
    Y_new = zeros(1,idx_end-idx_start+1);
    for k=1:idx_end-idx_start+1
        Y_new(k) = mode(label_cluster(:,k));
    end
    Y_new =Y_true;
    acc_pseudo = sum(Y_new == Y_true)/length(Y_true);
    recall_pseudo = recall(Y_new, Y_true);
    f1_pseudo = f1(acc_pseudo, recall_pseudo);
    acc_pseudo_hist = [acc_pseudo_hist,acc_pseudo];
    recall_pseudo_hist = [recall_pseudo_hist,recall_pseudo];
    f1_pseudo_hist = [f1_pseudo_hist, f1_pseudo];
    X_retrain = [X_retrain, X_new];
    Y_retrain = [Y_retrain, Y_new];
    for k=1:4
        classifiers{k} = fitcdiscr(X_retrain(k,:).',Y_retrain);
    end
    pred = assemble_model(classifiers,X_val.');
    % History
    acc_new = sum(Y_val == pred)/length(Y_val);
    acc_hist = [acc_hist, acc_new];
    recall_new = recall(pred, Y_val);
    recall_hist = [recall_hist,recall_new];
    f1_new = f1(acc_new, recall_new);
    f1_hist = [f1_hist, f1_new];
    for k = 1:class_num
        temp = Y_retrain == (k-1);
        S.mu(k,:) = mean(X_retrain(:,temp),2);
    end
    S.Sigma = zeros(size(X_retrain,1),class_num);
    for k = 1:class_num
        temp = Y_retrain == (k-1);
        S.Sigma(:, k) = var(X_retrain(:,temp),0,2);
    end
    S.ComponentProportion = zeros(1,class_num);
    for k = 1:class_num
        temp = Y_retrain == (k-1);
        S.ComponentProportion(k) = sum(temp)/size(X_retrain,2);
    end
    for k=1:4
        s.mu = S.mu(:,k);
        s.Sigma = zeros(1,1,class_num);
        s.Sigma(1,1,:) = S.Sigma(k,:);
        s.ComponentProportion = S.ComponentProportion;
        clusters{k}=fitgmdist(X_retrain(k,:).',class_num,"Start",s); 
    end
end

