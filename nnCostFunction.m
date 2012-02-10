function [ J, grad ] = nnCostFunction(nn, X, y, lambda, nn_params)
%NNCOSTFUNCTION Implements the neural network cost function for a neural
%network which performs classification
% [J, grad] = NNCOSTFUNCTION(nn, X, y, lambda, nn_params) computes the
% cost and gradient of the neural network. The parameters for the neural 
% network are as follows.
% NNCOSTFUNCTION(nn, X, y, lambda)
%   nn: The neural network to evaluate
%   X: The input from the training data
%   y: The outputs from the training data
%   lambda: The regularization parameter
% NNCOSTFUNCTION(nn, X, y, lambda, new_theta_vec)
%   nn_params: rolled-up theta vector to use instead of the neural
%              network's original thetas
%
%   ...other parameters as above
%
% See also NNROLL, NNUNROLL
%

% Check the number of arguments
if(nargin > 5 || nargin < 4)
    error('nn:nnCostFunction:TooManyInputs', ...
        'Number of input parameters should be in the range: [4, 5]');
elseif (nargin == 5)
    % If 
    nn = nnRoll(nn, nn_params);
end

% Setup some useful variables
m = size(X, 1);
labels_count = nn.layer_sizes(nn.layers_count);

% Perform forward propagation
nn.a{1} = X;
nn.z{2} = [ones(m, 1) X] * nn.theta{1}';
for i = 2:(nn.theta_count)
    nn.a{i} = sigmoid(nn.z{i});
    nn.z{i + 1} = [ones(size(nn.a{i}, 1), 1) nn.a{i}] * nn.theta{i}';
end
nn.a{nn.theta_count + 1} = sigmoid(nn.z{nn.theta_count + 1});

% ----------------------- Compute cost ---------------------------------- %
% Create a mask for output to be a bit-vector mask instead of real number
y_replicated = repmat(y, 1, labels_count);
masked_y = repmat(1:labels_count, m, 1) == y_replicated;

% Compute cost (unregularized)
ones_for_cost = ones(m, labels_count);
a_final = nn.a{nn.theta_count + 1};
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

% ------------------------ Compute gradient ----------------------------- %
% Initialize theta_grad to zeros
grad = zeros(nn.theta_total_numel, 1);
for k = 1:nn.theta_count
    nn.theta_grad{k} = zeros(size(nn.theta{k}));
end

% Perform back propagation
deltaAtOutput = a_final - masked_y;
for l = 1:m
    for u = fliplr(1:nn.theta_count)
        if u == nn.theta_count
            deltaNext = deltaAtOutput(l, :)';
            aCurrent = nn.a{u}(l, :);
                nn.theta_grad{u} = nn.theta_grad{u} + ...
                deltaNext * [1 aCurrent];
        else
            deltaNext = (nn.theta{u + 1}' * deltaNext) .* ...
                [1 sigmoidGradient(nn.z{u + 1}(l, :))]';
            deltaNext = deltaNext(2: end);
            nn.theta_grad{u} = nn.theta_grad{u} + deltaNext * [1 nn.a{u}(l, :)];
        end
    end
end

% Regularize the gradients
begin_index = 1;
for i = 1:nn.theta_count
    theta_reg = [zeros(size(nn.theta{i}, 1), 1) lambda * nn.theta{i}(:, 2:end)];
    nn.theta_grad{i} = 1/m * (nn.theta_grad{i} + theta_reg);
    
    % Unroll the gradient
    end_index = begin_index + numel(theta_reg) - 1;
    grad(begin_index:end_index) = nn.theta_grad{i}(:);
    begin_index = end_index + 1;
end