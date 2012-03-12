function  testVisualize2dNonLinear
%TESTVISUALIZE2DNONLINEAR Tests visualize2dNonLinearBoundary function


X = randn(125, 2);
y = withinTheCircle(X(:, 1), X(:, 2), 0.5);

predict = @(input)withinTheCircle(input(:, 1), input(:, 2), 0.5);
visualize2dNonLinearBoundary(X, y, @(input)predict(input))

end


function output = withinTheCircle(x1, x2, radius)
    output = x1 .^ 2 + x2 .^ 2 <= radius .^ 2;
end