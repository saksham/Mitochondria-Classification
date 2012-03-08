function testLogReg

data = load('ex2data1.txt');
X = data(:, [1, 2]); y = data(:, 3);


initial_theta = zeros(size(X, 2), 1);
lambda = 1;

% Set options and optimize
options = optimset('GradObj', 'on', 'MaxIter', 400);
[theta, J, exit_flag] = ...
	fminunc(@(t)(costFunctionReg(t, X, y, lambda)), initial_theta, options);

% Compute accuracy on our training set
p = predict(theta, X);
accuracy = mean(double(p == y)) * 100;
assert(accuracy > 90.0);

end