function [ new_y ] = svmLinearPredict( new_X, param )
% SVMLINEARPREDICT Predicts classes for given features using a linear
% decision boundary. The decision boundary may come from a SVM.
%   new_X: features to predict
%   param: parameters containing w and b to get the decision boundary

% initialization
size_X = size(new_X);
n = size_X(1);
new_y = zeros(n,1);
W = param.('W');
b = param.('b');

% prediction
for i = 1 : n
    if (W' * new_X(i,:)' + b) > 0
        new_y(i) = 1;
    else
        new_y(i) = -1;
    end
end

end

