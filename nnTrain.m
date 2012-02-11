function [ nn_new ] = nnTrain(nn, X, y, lambda, maxIter)
%NNTRAIN Trains a neural network for the given training data
%   [nn] = nnTrain(nn, X, y, lambda, maxIter): Trains a neural network
%   given the training data, and some options.
%   X: The training images
%   y: The training labels
%   lambda: The regularization constant
%   maxIter: the number of times the optimization iteration is performed.
%
% See also: FMINCG
%

    % Set optimization options
    options = optimset('MaxIter', maxIter);

    
    % Create "short hand" for the cost function to be minimized
    costFunction = @(p) nnCostFunction(nn, X, y, lambda, p);

    % Now, costFunction is a function that takes in only one argument (the
    % neural network parameters)
    [nn_params, cost] = fmincg(costFunction, nnUnroll(nn), options);

    % Roll nn_params to set the weights of the neural network
    nn_new = nnRoll(nn, nn_params);
end
