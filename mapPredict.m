function [ y_pred ] = mapPredict( X, param )
% MAPPREDICT: Predicts class labels of the data set X using covariances and
% means stored in params. Prediction is based on a Multivariate Gaussian
% distribution.
% [ y_pred ] = mapPredict( X, param )
%   X: the data set
%   param: parameters for the prediction (covariance and mean for each 
%   class)

% training parameters
COV = param.('COV');
MU = param.('MU');
labels = param.('labels');

% initializations
size_X = size(X);
n = size_X(1);
y_pred = zeros(n,1);
c = length(labels);

% prediction
for i = 1 : n
    results = zeros(c,1);
    for k = 1 : c
        results(k) = 1/sqrt(det(2*pi*COV(:,:,k))) * ...
            exp(-(1/2)*(X(i,:)-MU(k,:))/(COV(:,:,k))*(X(i,:)-MU(k,:))');
    end
    [C , I] = max(results);
    y_pred(i) = labels(I);
end

end

