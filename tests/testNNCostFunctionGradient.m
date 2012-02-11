% ACKNOWLEDGEMENT: This test is largely based on the Assignment sheet for
% Machine Learning online class taught by professor Andrew NG. For more
% details, please visit: http://ml-class.org/
function testNNCostFunctionGradient
    % Load the training data and parameters
    fprintf('\nLoading data and parameters...')
    load('data/ml-class_ex4data1.mat');
    load('data/ml-class_ex4weights.mat');

    fprintf('\nChecking numerical gradients for lambda = 0 ...');
    lambda = 0;
    diff = checkNNGradients(lambda);
    assert(diff < 1e-9, 'The unregularized gradient computation is incorrect');
    
    fprintf('\nChecking numerical gradients for lambda = 1 ...');
    lambda = 3;
    diff = checkNNGradients(3);
    assert(diff < 1e-9, 'The regularized gradient computation is incorrect');
    
    nn = nnCreate(400, 10, 25);
    nn.theta{1} = Theta1;
    nn.theta{2} = Theta2;
    cost  = nnCostFunction(nn, X, y, lambda);
    assertElementsAlmostEqual(0.576051, cost, 'absolute', 1e-6);
end

function [diff] = checkNNGradients(lambda)
%CHECKNNGRADIENTS Creates a small neural network to check the
%backpropagation gradients
%   CHECKNNGRADIENTS(lambda) Creates a small neural network to check the
%   backpropagation gradients, it will output the analytical gradients
%   produced by your backprop code and the numerical gradients (computed
%   using computeNumericalGradient). These two gradient computations should
%   result in very similar values.
%
    if ~exist('lambda', 'var') || isempty(lambda)
        lambda = 0;
    end

    % We generate some 'random' test data
    input_layer_size = 3;
    hidden_layer_size = 5;
    num_labels = 3;
    m = 5;
    % Reusing debugInitializeWeights to generate X
    X  = debugInitializeWeights(m, input_layer_size - 1);
    y  = 1 + mod(1:m, num_labels)';

    % Create the neural network
    nn = nnCreate(input_layer_size, num_labels, hidden_layer_size);
    nn.theta{1} = debugInitializeWeights(hidden_layer_size, input_layer_size);
    nn.theta{2} = debugInitializeWeights(num_labels, hidden_layer_size);
    
    %Unroll the neural network's theta matrices
    nn_params = nnUnroll(nn);
    
    % Short hand for cost function
    costFunc = @(p) nnCostFunction(nn, X, y, lambda, p);

    [cost, grad] = costFunc(nn_params);
    numgrad = computeNumericalGradient(costFunc, nn_params);

    % Visually examine the two gradient computations.  The two columns
    % you get should be very similar. 
    %disp([numgrad grad]);
    
    % Evaluate the norm of the difference between two solutions.  
    % If the implementation is correct, and assuming EPSILON = 0.0001 
    % in computeNumericalGradient, then diff below should be less than 1e-9
    diff = norm(numgrad-grad)/norm(numgrad+grad);
end

function W = debugInitializeWeights(fan_out, fan_in)
%DEBUGINITIALIZEWEIGHTS Initialize the weights of a layer with fan_in
%incoming connections and fan_out outgoing connections using a fixed
%strategy, this will help you later in debugging
%   W = DEBUGINITIALIZEWEIGHTS(fan_in, fan_out) initializes the weights 
%   of a layer with fan_in incoming connections and fan_out outgoing 
%   connections using a fix set of values
%
%   Note that W should be set to a matrix of size(1 + fan_in, fan_out) as
%   the first row of W handles the "bias" terms
%
    % Set W to zeros
    W = zeros(fan_out, 1 + fan_in);

    % Initialize W using "sin", this ensures that W is always of the same
    % values and will be useful for debugging
    W = reshape(sin(1:numel(W)), size(W)) / 10;
end

function numgrad = computeNumericalGradient(J, theta)
%COMPUTENUMERICALGRADIENT Computes the gradient using "finite differences"
%and gives us a numerical estimate of the gradient.
%   numgrad = COMPUTENUMERICALGRADIENT(J, theta) computes the numerical
%   gradient of the function J around theta. Calling y = J(theta) should
%   return the function value at theta.

% Notes: The following code implements numerical gradient checking, and 
%        returns the numerical gradient.It sets numgrad(i) to (a numerical 
%        approximation of) the partial derivative of J with respect to the 
%        i-th input argument, evaluated at theta. (i.e., numgrad(i) should 
%        be the (approximately) the partial derivative of J with respect 
%        to theta(i).)
%                

    numgrad = zeros(size(theta));
    perturb = zeros(size(theta));
    e = 1e-4;
    for p = 1:numel(theta)
        % Set perturbation vector
        perturb(p) = e;
        loss1 = J(theta - perturb);
        loss2 = J(theta + perturb);
        % Compute Numerical Gradient
        numgrad(p) = (loss2 - loss1) / (2*e);
        perturb(p) = 0;
    end

end