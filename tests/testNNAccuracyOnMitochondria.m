function [ errTrain , errCv ] = testMapAccuracyOnMitochondria( x )
%TESTIMAGEFEATUREEXTRACTION Summary of this function goes here
%   Detailed explanation goes here

%Paths
str = strrep(pwd, '/tests', '');
addpath(str);
str = strrep(pwd, '/tests', '/xunit');
addpath(str);

% Check for input variables
if nargin == 0
    x = [0.8438 0.1094];
end

black_percentage = x(1);
white_percentage = x(2);
disp([num2str(black_percentage) ' : ' num2str(white_percentage)]);

% Create a neural network
input_layer_size = 400;     % 20x20 imput images of digits
hidden_layer_size = 10;     % Just 1 hidden layer with 10 nodes
num_labels = 2;            % 2 labels, from 1 to 2
nn = nnCreate(input_layer_size, num_labels, hidden_layer_size);

y_vec_struct = load('../data/y_vec.mat');
y_vec = y_vec_struct(1).('y_vec');

images_struct = load('../data/images.mat');
images = images_struct(1).('images');

size_images = size(images);
n = size_images(2);

image = images{1};
size_image = size(image);

images_as_matrix = zeros(n,size_image(1),size_image(2));
for i = 1 : n
    images_as_matrix(i,:,:) = images{i};
end

% Initialize training and prediction algorithms
trainFn = @(xTrain, yTrain)testNNTrainOnMitochondria(xTrain, yTrain, nn, black_percentage, white_percentage);
predictFn = @(xTest, options)testNNPredictOnMitochondria(xTest, options);

ind = find(y_vec == -1);
ind_size = length(ind);

y_vec(ind) = y_vec(ind) + 3*ones(ind_size,1);
    
[errTrain, errCv] = calculateAccuracy(images_as_matrix, y_vec, trainFn, predictFn, 20);
end
