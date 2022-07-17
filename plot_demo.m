clc;
clear;
load("Data.mat");
%% Data split
i=1;
num = Data(i).samples;
ratio_val = 0.2;
idx0 = Data(i).label == 0;
idx1 = Data(i).label == 1;
idx2 = Data(i).label == 2;
idx3 = Data(i).label == 3;
idx4 = Data(i).label == 4;
x_0 = Data(i).features(:, idx0);
x_1 = Data(i).features(:, idx1);
x_2 = Data(i).features(:, idx2);
x_3 = Data(i).features(:, idx3);
x_4 = Data(i).features(:, idx4);
y_0 = Data(i).label(:, idx0);
y_1 = Data(i).label(:, idx1);
y_2 = Data(i).label(:, idx2);
y_3 = Data(i).label(:, idx3);
y_4 = Data(i).label(:, idx4);
truncate = min([size(y_0, 2),size(y_1, 2),size(y_2, 2),size(y_3, 2),size(y_4, 2)]);
x_0 = x_0(:, 1: truncate);
x_1 = x_1(:, 1: truncate);
x_2 = x_2(:, 1: truncate);
x_3 = x_3(:, 1: truncate);
x_4 = x_4(:, 1: truncate);
y_0 = y_0(:, 1: truncate);
y_1 = y_1(:, 1: truncate);
y_2 = y_2(:, 1: truncate);
y_3 = y_3(:, 1: truncate);
y_4 = y_4(:, 1: truncate);
X = [x_0, x_1, x_2, x_3, x_4];
Y = [y_0, y_1, y_2, y_3, y_4];
new_idx = randperm(length(Y));
X = X(:, new_idx);
Y = Y(new_idx);
X_val = X(:, 1:30);
Y_val = Y(1:30);

X_init_train = X(:, 31:end);
Y_init_train = Y(31:end);

%% Init train
% Classifiers
classifiers = cell(4,1);
% Train
for j=1:4
    classifiers{j} = fitcdiscr(X_init_train(j,:).',Y_init_train);
end
% Accuracy of each band
acc = zeros(4,1);
for j=1:4
    acc(j) = sum(Y_val.' == predict(classifiers{j}, X_val(j,:).'))/length(Y_val);
end
pred = assemble_model(classifiers,X_val.');
% History
acc_init = sum(Y_val == pred)/length(Y_val);
recall_init = recall(pred, Y_val);
f1_init = f1(acc_init, recall_init);
hold on
stairs(pred,'LineWidth',2)
stairs(Y_val,'LineWidth',2)
legend('pred','ture');
hold off