function [J, grad] = logRegCostFunction(X, y, theta, lambda)
%LOGREGCOSTFUNCTION Compute cost and gradient for logistic regression with regularization
%   J = LOGREGCOSTFUNCTION(X, y, theta, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples
n = size(X, 2); % number of features

% Compute the cost
h_theta = sigmoid(X * theta);
J = 1.0/m *  (-y' * log(h_theta) - (1 - y)' * log(1 - h_theta));
J = J + 0.5 * lambda / m * theta(2:end)' * theta(2:end);

% Compute the gradient
grad = zeros(n,1);
for i = 1:size(X,2)
    grad(i) = 1.0 / m * (h_theta - y)' * X(:, i);
    grad(i) = grad(i) + (i > 1) * lambda / m * theta(i);
end

end