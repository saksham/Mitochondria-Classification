function visualize2dNonLinearBoundary(X, y, classifierFn)
% VISUALIZE2DNONLINEARBOUNDARY plots a non-linear decision boundary 
%   PLOT2DNONLINEARBOUNDARY(X, y, predictFn, params) plots a non-linear 
%   decision boundary for a classifier and overlays the data on it
%       X: 2D input data
%       y: labels for the input data
%       classifierFn: classifier function with the signature:
%           classifierFn(X)
%       params: any additional parameter
%

if size(X, 2) == 2
    X = [ones(size(X, 1), 1) X];
end

% Plot the training data on top of the boundary
plot2dDataWithLabels([X(:, 2) X(:, 3)], y)

% Make classification predictions over a grid of values
gridsCount = 1000;
x1plot = linspace(min(X(:,2)), max(X(:,2)), gridsCount)';
x2plot = linspace(min(X(:,3)), max(X(:,3)), gridsCount)';
[X1, X2] = meshgrid(x1plot, x2plot);
vals = zeros(size(X1));
for i = 1:size(X1, 2)
   this_X = [X1(:, i), X2(:, i)];
   vals(:, i) = classifierFn(this_X);
end

% Plot the boundary
hold on
contour(X1, X2, vals, [0 0], 'Color', 'b');
hold off;

end