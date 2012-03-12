function testCalculateAccuracy
%TESTCALCULATEACCURACY Functional test for calculateAccuracy function
%   Checks whether training and cross-validation error for a simple
%   function is computed correctly.

    X = randn(101, 2);
    radius = 0.5;
    y = isWithinCircle(X(:, 1), X(:, 2), radius + 0.5);
    
    predict = @(input)isWithinCircle(input(:, 1), input(:, 2), radius);
    visualize2dNonLinearBoundary(X, y, @(input)predict(input))
    
    trainFn = @(xTrain, yTrain)pretendToFindTheRadius(xTrain(:, 1), xTrain(:, 2), 0.5);
    predictFn = @(xTest, options)isWithinCircle(xTest(:, 1), xTest(:, 2), options);
    
    [errTrain, errCv] = calculateAccuracy(X, y, trainFn, predictFn, 10);
    assert(errTrain > 0, 'Average training error should be greater than zero');
    assert(errCv > 0, 'Average cross-validation error should be greater than zero');
end

function [radius] = pretendToFindTheRadius(xTrain, yTrain, theRadiusToSet)
    radius = theRadiusToSet;
end

function [result] = isWithinCircle(x1, x2, radius)
    result = x1 .^ 2 + x2 .^ 2 <= radius .^ 2;
end
