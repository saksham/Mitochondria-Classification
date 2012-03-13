function testCalculateAccuracy
%TESTCALCULATEACCURACY Functional test for calculateAccuracy function
%   Checks whether training and cross-validation error for a simple
%   function is computed correctly.

    %Paths
    str = strrep(pwd, '/tests', '');
    addpath(str);
    str = strrep(pwd, '/tests', '/xunit');
    addpath(str);

    X = randn(101, 2);
    radius = 0.5;
    y = isWithinCircle(X(:, 1), X(:, 2), radius + 0.5);
    
    % Initialize training and prediction algorithms
    trainFn = @(xTrain, yTrain)prentendToTrain(xTrain(:, 1), xTrain(:, 2), 0.5);
    predictFn = @(xTest, options)isWithinCircle(xTest(:, 1), xTest(:, 2), options);
    
    [errTrain, errCv] = calculateAccuracy(X, y, trainFn, predictFn, 10);
    assert(errTrain > 0, 'Average training error should be greater than zero');
    assert(errCv > 0, 'Average cross-validation error should be greater than zero');
end

function [radius] = prentendToTrain(xTrain, yTrain, theRadiusToSet)
    %PRETENDTOTRAIN prenteds to be an ML training algorithm
    %   [radius] = pretendToTrain(xTrain, yTrain, theRadiusToSet) pretends
    %       as if it is learning the radius from the given training samples
    %       and data. Actually the method just returns whatever value of
    %       radius was provided as one of the parameters: theRadiusToSet
    %
    radius = theRadiusToSet;
end

function [result] = isWithinCircle(x1, x2, radius)
    % ISWITHINCIRCLE checks whether the coordinates lie within the circle
    %   [result] = isWithinCircle(x1, x2, radius): evaluates and returns a
    %   logical value representing whether or not the coordinates lie
    %   within the circle centered at (0, 0) or not.
    %
    result = x1 .^ 2 + x2 .^ 2 <= radius .^ 2;
end
