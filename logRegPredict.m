function p = logRegPredict(X, theta)
%LOGREGPREDICT Predict whether the label is 0 or 1 using learned logistic 
%regression parameters theta
%   p = LOGREGPREDICT(X, theta) computes the predictions for X using a 
%   threshold at 0.5 (i.e., if sigmoid(theta'*x) >= 0.5, predict 1)

if(size(theta, 1) - size(X, 2) == 1)
    X = [ones(size(X, 1), 1) X];
end

h_theta = sigmoid(X * theta);
p = h_theta > 0.5; 
end