function testLogRegWithImage

%Paths
str = strrep(pwd, '/tests', '');
addpath(str);
str = strrep(pwd, '/tests', '/xunit');
addpath(str);

% Read the values for input and labels
images_struct = load('../data/images.mat');
images = images_struct(1).('images');
y_vec_struct = load('../data/y_vec.mat');
y_vec = y_vec_struct(1).('y_vec');

% Change the labels to {0, 1} instead of {-1, 1}
y_vec = (y_vec + 1) / 2;

X = [];
y = [];
for i = 1:size(images, 2)
    I = images{i};
    blobs = blobVector(I, 0.84, 0.11);
    x_i = featureExtractionBoundaries(blobs);
    X = [X; x_i];
    
    % The labels for the entire image will be the label for each mitochondria
    y_i = repmat(y_vec(i), size(x_i, 1), 1);
    y = [y; y_i];
end
X = [ones(size(X, 1), 1) X];

plot2dDataWithLabels(X, y);
initial_theta = zeros(size(X, 2), 1);
lambda = 0;

% Set options and optimize
options = optimset('GradObj', 'on', 'MaxIter', 400);
[theta, J, exit_flag] = ...
	fminunc(@(t)(logRegCostFunction(t, X, y, lambda)), initial_theta, options);

% Compute accuracy on our training set
p = logRegPredict(theta, X);
accuracy = mean(double(p == y)) * 100
assert(accuracy > 80.0);

end