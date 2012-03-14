function [ overall_error ] = testNNOnMitochondria( x )
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

% Create a neural network
input_layer_size = 400;     % 20x20 imput images of digits
hidden_layer_size = 30;     % Just 1 hidden layer with 10 nodes
num_labels = 2;            % 2 labels, from 1 to 2
nn = nnCreate(input_layer_size, num_labels, hidden_layer_size);

black_percentage = x(1);
white_percentage = x(2);
disp([num2str(black_percentage) ' : ' num2str(white_percentage)]);

%---Training--------------------------------------------------------------%
y_vec_struct = load('../data/y_vec.mat');
y_vec = y_vec_struct(1).('y_vec');

images_struct = load('../data/images.mat');
images = images_struct(1).('images');

%faster
%fast = [1 2 3 4 5 6 7 8 9 10 21 22 23 24 25 26 27 28 29 30];
% fast = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 ...
%     20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44];
fast = [1 3 5 7 9 11 13 ...
    21 23 25 27 29 31 33 35 37 39 41 43 ...
    2 4 6 8 10 12 14 ...
    20 22 24 26 28 30 32 34 36 38 40 42 44];
y_vec_fast = zeros(length(fast),1);
images_fast = cell(1);

for k = 1 : length(fast)
    images_fast{k} = images{fast(k)};
    y_vec_fast(k) = y_vec(fast(k));
end

images = images_fast;
y_vec = y_vec_fast;

ind = find(y_vec == -1);
ind_size = length(ind);
y_vec(ind) = y_vec(ind) + 3*ones(ind_size,1);

size_images = size(images);
n = size_images(2);
image = images{1};
size_image = size(image);
images_as_matrix = zeros(n,size_image(1),size_image(2));
for i = 1 : n
    images_as_matrix(i,:,:) = images{i};
end

% size_images = size(images);
% n = size_images(2);
% counter = 0;
% for i = 1 : n
%     I = images{i};
%     blobs = blobVector(I , black_percentage , white_percentage);
%     m = length(blobs);
%     for k = 1 : m
%         counter = counter + 1;
%         b = blobs{k};
%         B = resizeBlob(b);
%         features(counter,:) = B(:);
%         if y_vec(i) == -1
%             y(counter) = 2;
%         else
%             y(counter) = y_vec(i);
%         end
%     end
% end
% nn = nnTrain(nn, features, y', 2, 50);

param = testNNTrainOnMitochondria(images_as_matrix, y_vec, nn, black_percentage , white_percentage);

%---Prediction------------------------------------------------------------%
y_vec_struct = load('../data/y_vec.mat');
y_vec = y_vec_struct(1).('y_vec');

images_struct = load('../data/images.mat');
images = images_struct(1).('images');

fast = [15 16 17 18 19];
y_vec_fast = zeros(length(fast),1);
images_fast = cell(1);

for k = 1 : length(fast)
    images_fast{k} = images{fast(k)};
    y_vec_fast(k) = y_vec(fast(k));
end

images = images_fast;
y_vec = y_vec_fast;

ind = find(y_vec == -1);
ind_size = length(ind);
y_vec(ind) = y_vec(ind) + 3*ones(ind_size,1);

size_images = size(images);
n = size_images(2);
image = images{1};
size_image = size(image);
images_as_matrix = zeros(n,size_image(1),size_image(2));
for i = 1 : n
    images_as_matrix(i,:,:) = images{i};
end

% size_images = size(images);
% n = size_images(2);
% for i = 1 : n
%     I = images{i};
%     blobs = blobVector(I , black_percentage , white_percentage);
%     m = length(blobs);
%     new_features = zeros(m,input_layer_size);
%     for k = 1 : m
%         B = resizeBlob(blobs{k});
%         new_features(k,:) = B(:);
%     end
%     y_pred_image = nnPredict(nn, new_features);
%     result = sum(y_pred_image);
%     disp(num2str(result/m));
%     if(result/m < 1.5)
%         y_pred(i) = 1;
%     else
%         y_pred(i) = 2;
%     end
%     % Plot
%     %visualizeBlobPrediction(I, blobs, y_pred_image);
% end
y_pred = testNNPredictOnMitochondria(images_as_matrix, param);

%---Accuracy--------------------------------------------------------------%
trainingSetAccuracy = mean(double(y_pred == y_vec)) * 100;

overall_error = 100 - trainingSetAccuracy;
disp(['ERROR(overall_error): ' num2str(overall_error)]);

end