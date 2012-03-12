function testLogRegWithImage

%Paths
str = strrep(pwd, '/tests', '');
addpath(str);
str = strrep(pwd, '/tests', '/xunit');
addpath(str);

% Read the values for input and labels
images_struct = load('data/images.mat');
images = images_struct(1).('images');
y_vec_struct = load('data/y_vec.mat');
y_vec = y_vec_struct(1).('y_vec');


m = size(images, 2);
n = 2;
X = ones(m, n + 1);
y = (y_vec + 1 ) / 2;  % Change the labels to {0, 1} instead of {-1, 1}
for i = 1:size(images, 2)
    I = images{i};
    blobs = blobVector(I, 0.84, 0.11);
    x_i = featureExtractionBoundaries(blobs);
    X(i, 2:end) = mean(x_i);
end

initial_theta = zeros(size(X, 2), 1);
lambda = 0;

% Set options and optimize
options = optimset('GradObj', 'on', 'MaxIter', 500);
[theta, J, exit_flag] = ...
	fminunc(@(t)(logRegCostFunction(X, y, t, lambda)), initial_theta, options);

% Plot decision boundary
plot2dLinearDecisionBoundary(X, y, theta);

% Compute accuracy on our training set
p = logRegPredict(X, theta);
accuracy = mean(double(p == y)) * 100;
assert(accuracy > 80.0);

end