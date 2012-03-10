function testLogReg

data = load('../data/ex2data1.txt');
X = data(:, [1, 2]); y = data(:, 3);
X = [ones(size(X, 1), 1) X];

initial_theta = zeros(size(X, 2), 1);
lambda = 0;

% Set options and optimize
options = optimset('GradObj', 'on', 'MaxIter', 400);
[theta, J, exit_flag] = ...
	fminunc(@(t)(logRegCostFunction(t, X, y, lambda)), initial_theta, options);

% Compute accuracy on our training set
p = logRegPredict(theta, X);
accuracy = mean(double(p == y)) * 100
assert(accuracy > 80.0);

end