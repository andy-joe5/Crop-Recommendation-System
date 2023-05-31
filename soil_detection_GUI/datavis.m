% Load your dataset
addpath(genpath('.\Alluvial soil'));
% Extract the features you want to use
X = meas(:,3:4);
Y = species;

% Train an SVM on the dataset
svm = fitcsvm(X,Y);

% Extract the support vectors
sv = svm.SupportVectors;

% Define a grid of points over the feature space
[x1,x2] = meshgrid(min(X(:,1)):0.01:max(X(:,1)),min(X(:,2)):0.01:max(X(:,2)));
XGrid = [x1(:),x2(:)];

% Classify each point in the grid using the SVM
[~,scores] = predict(svm,XGrid);

% Reshape the predicted scores into the original grid shape
scoreGrid = reshape(scores(:,2),size(x1));

% Plot the data points and the decision boundary
figure;
gscatter(X(:,1),X(:,2),Y);
hold on;
contour(x1,x2,scoreGrid,[0 0],'k');
scatter(sv(:,1),sv(:,2),'MarkerEdgeColor','k','MarkerFaceColor','g', 'LineWidth', 2);
xlabel('Feature 1');
ylabel('Feature 2');
legend('Setosa','Versicolor','Decision boundary','Support vectors');
