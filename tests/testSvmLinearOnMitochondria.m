function [ overall_error ] = testSvmLinearOnMitochondria( x )
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

max_x1 = max(features(:,1));
max_x2 = max(features(:,2));
features(:,1) = features(:,1)./max_x1;
features(:,2) = features(:,2)./max_x2;


[W , b] = svmLinear(features,y_vec,1000);

y_pred = svmLinearPredict(W, b, features);

trainingSetAccuracy = mean(double(y_pred == y_vec)) * 100;

overall_error = 100 - trainingSetAccuracy;
disp(['ERROR(overall_error): ' num2str(overall_error)]);

end
