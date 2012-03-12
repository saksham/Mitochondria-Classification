function  testVisualize2dNonLinear
%TESTVISUALIZE2DNONLINEAR Summary of this function goes here
%   Detailed explanation goes here

data = load('data/ex2data1.txt');
X = data(:, [1, 2]); y = data(:, 3);
X = [ones(size(X, 1), 1) X];

initial_theta = zeros(size(X, 2), 1);
lambda = 0;

% Set options and optimize
options = optimset('GradObj', 'on', 'MaxIter', 400);
[theta, J, exit_flag] = ...
	fminunc(@(t)(logRegCostFunction(X, y, t, lambda)), initial_theta, options);

% Compute accuracy on our training set
p = logRegPredict(X, theta);
accuracy = mean(double(p == y)) * 100;
assert(accuracy > 85.0);

predict = @(input)logRegPredict(input, theta);
visualize2dNonLinearBoundary(X, y, @(input)predict(input))

end

