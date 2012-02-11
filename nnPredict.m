function p = nnPredict(nn, X)
%PREDICT Predict the label of an input given a trained neural network
%   p = PREDICT(nn, X) outputs the predicted label of X given the neural
%   network with trained weights
%

    % Useful values
    m = size(X, 1);

    % Perform forward propagation
    activations = X;
    for i = 1:nn.theta_count
        activations = sigmoid([ones(m, 1) activations] * nn.theta{i}');
    end
    [dummy, p] = max(activations, [], 2);
end