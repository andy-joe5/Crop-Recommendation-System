%% SVM using various Kernels
%% Data Preprocessing
%%
clear all;clc;
data=csvread('GaussianData.csv');

% Training & testing sets
[data_train,data_test] = holdout(data,80);
Xtrain = data_train(:,1:end-1); 
Ytrain = data_train(:,end);
Xtest = data_test(:,1:end-1);
Ytest = data_test(:,end);

% Scatter Plot of data
figure
hold on
X=[Xtrain;Xtest];Y=[Ytrain;Ytest];
scatter(X(Y==1,1),X(Y==1,2),'+g')
scatter(X(Y==-1,1),X(Y==-1,2),'.r')
hold off
%% Applying linear Kernel
%%
linear_in=fitcsvm(Xtrain,Ytrain,'KernelFunction','linear');
linear_out=predict(linear_in,Xtest);
[~,acc_linear,fm_Linear]=confusionMatrix(Ytest,linear_out)
%% Decision Boundry in input space (Linear Kernel)
%%
x1range=min(data(:,1)):0.005:max(data(:,1));
x2range=min(data(:,2)):0.005:max(data(:,2));

[x1 x2]=meshgrid(x1range,x2range);

X1n=reshape(x1,1,size(x1,2)*size(x1,1));
X2n=reshape(x2,1,size(x2,2)*size(x2,1));
Xn=[X1n' X2n'];

yn=predict(linear_in,Xn);
Yn=reshape(yn,size(x1));

figure
hold on
imagesc([min(Xtest(:,1)) max(Xtest(:,1))], [min(Xtest(:,2)) max(Xtest(:,2))], Yn);
scatter(Xtest(Ytest==1,1),Xtest(Ytest==1,2),'+g')
scatter(Xtest(Ytest==-1,1),Xtest(Ytest==-1,2),'.r')
axis([min(Xtest(:,1)) max(Xtest(:,1)) min(Xtest(:,2)) max(Xtest(:,2))])
hold off
