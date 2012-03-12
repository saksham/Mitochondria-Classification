function [ overall_error ] = testLogRegOnMitochondria( x )
%TESTIMAGEFEATUREEXTRACTION Summary of this function goes here
%   Detailed explanation goes here

%Paths
str = strrep(pwd, '/tests', '');
addpath(str);
str = strrep(pwd, '/tests', '/xunit');
addpath(str);

black_percentage = x(1);
white_percentage = x(2);
disp([num2str(black_percentage) ' : ' num2str(white_percentage)]);

y_vec_struct = load('../data/y_vec.mat');
y_vec = y_vec_struct(1).('y_vec');

images_struct = load('../data/images.mat');
images = images_struct(1).('images');

%faster
% fast = [1 2 3 4 5 6 7 8 9 10 21 22 23 24 25 26 27 28 29 30];
% y_vec_fast = zeros(length(fast),1);
% images_fast = cell(1);
% 
% for k = 1 : length(fast)
%     images_fast{k} = images{fast(k)};
%     y_vec_fast(k) = y_vec(fast(k));
% end
% 
% images = images_fast;
% y_vec = y_vec_fast;

features = imageFeatureExtraction(images, black_percentage, white_percentage);

% Change the labels to {0, 1} instead of {-1, 1}
y_vec = (y_vec + 1) / 2;

features = [ones(size(features, 1), 1) features];

initial_theta = zeros(size(features, 2), 1);
lambda = 0;
% Set options and optimize
options = optimset('GradObj', 'on', 'MaxIter', 500);
[theta, J, exit_flag] = ...
	fminunc(@(t)(logRegCostFunction(t, features, y_vec, lambda)), initial_theta, options);


plot2dDecisionBoundary(theta, features, y_vec);

% Compute accuracy on our training set
y_pred = logRegPredict(theta, features);

trainingSetAccuracy = mean(double(y_pred == y_vec)) * 100;

overall_error = 100 - trainingSetAccuracy;
disp(['ERROR(overall_error): ' num2str(overall_error)]);

end
