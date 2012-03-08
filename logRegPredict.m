function p = logRegPredict(theta, X)
%LOGREGPREDICT Predict whether the label is 0 or 1 using learned logistic 
%regression parameters theta
%   p = LOGREGPREDICT(theta, X) computes the predictions for X using a 
%   threshold at 0.5 (i.e., if sigmoid(theta'*x) >= 0.5, predict 1)

h_theta = sigmoid(X * theta);
p = h_theta > 0.5; 
end