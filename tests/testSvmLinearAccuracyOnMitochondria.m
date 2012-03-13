function [ overall_error ] = testMapAccuracyOnMitochondria( x )
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

y_vec_struct = load('../data/y_vec.mat');
y_vec = y_vec_struct(1).('y_vec');

images_struct = load('../data/images.mat');
images = images_struct(1).('images');


overall_error = 0;

features = imageFeatureExtraction(images, black_percentage, white_percentage);

max_x1 = max(features(:,1));
max_x2 = max(features(:,2));
features(:,1) = features(:,1)./max_x1;
features(:,2) = features(:,2)./max_x2;

COV = zeros(2,2,2);
MU = zeros(2,2);

% Initialize training and prediction algorithms
trainFn = @(xTrain, yTrain)svmLinear(xTrain, yTrain, 1000);
predictFn = @(xTest, options)svmLinearPredict(xTest, options);
    
[errTrain, errCv] = calculateAccuracy(features, y_vec, trainFn, predictFn, 20);
end
