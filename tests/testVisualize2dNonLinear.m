function  testVisualize2dNonLinear
%TESTVISUALIZE2DNONLINEAR Summary of this function goes here
%   Detailed explanation goes here

predict = @(input)logRegPredict(input, theta);
visualize2dNonLinearBoundary(X, y, @(input)predict(input))

end

