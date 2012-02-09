function [ J, grad ] = nnCostFunction( nn,  X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a neural
%network which performs classification
% [J, grad] = NNCOSTFUNCTION(nn, X, y, lambda) computes the cost and
% gradient of the neural network. The parameters for the neural network
% are as follows.
% nn: The neural network to evaluate
% X: The input from the training data
% y: The outputs from the training data
% lambda: The regularization parameter

% Setup some useful variables
m = size(X, 1);
n = nn.layer_sizes(1);
labels_count = nn.layer_sizes(nn.layers_count);

% Perform forward propagation
a = X;
z = [ones(m, 1) a] * nn.theta{1}';

for i = 2:(nn.layers_count - 1)
    a = sigmoid(z);
    z = [ones(size(a, 1), 1) a] * nn.theta{i}';
end
a_final = sigmoid(z);

% Create a mask for output to be a bit-vector mask instead of real number  
y_replicated = repmat(y, 1, labels_count);
masked_y = repmat(1:labels_count, m, 1) == y_replicated;

% Compute cost (unregularized)
ones_for_cost = ones(m, labels_count);
first_term = masked_y .* log(a_final);
second_term = (ones_for_cost - masked_y) .* log(ones_for_cost - a_final);
unregularized_cost = -1 / m * sum(sum(first_term + second_term));

% Regularization of the cost
theta_squared_sum = 0;
for j = 1:(nn.layers_count - 1)
    effective_thetas = nn.theta{j}(:, 2:end);
    theta_squared_sum = theta_squared_sum + sum(sum(effective_thetas .^2));
end
regularization_factor = lambda / (2 * m) * theta_squared_sum;
J = unregularized_cost + regularization_factor;

end

