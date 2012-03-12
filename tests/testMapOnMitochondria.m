function [ overall_error ] = testMapOnMitochondria( x )
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


overall_error = 0;

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

COV = zeros(2,2,2);
MU = zeros(2,2);
[COV , MU] = MAP( COV , MU , length(y_vec) , features , y_vec , [-1 , 1] , [0 0] , [1 1]);

y_pred = mapPredict(COV , MU , [-1 , 1] , features);

% Plot
predict = @(input)mapPredict(COV , MU , [-1 , 1], input);
visualize2dNonLinearBoundary(features, y_vec, 1000, @(input)predict(input))
hold on;
grey = [0.4,0.4,0.4];
[x,y,z] = evalF(1,MU(1,:),COV(:,:,1));
contour(x,y,z,1,'Color',grey);
[x,y,z] = evalF(1,MU(2,:),COV(:,:,2));
contour(x,y,z,1,'Color',grey);
hold off;

trainingSetAccuracy = mean(double(y_pred == y_vec)) * 100;

overall_error = 100 - trainingSetAccuracy;
disp(['ERROR(overall_error): ' num2str(overall_error)]);

end

function [x,y,z] = evalF(c,mu,sigma)

rng = 0:.01:1;
[x,y] = meshgrid(rng,rng);
z = zeros(numel(rng),numel(rng));
inv_sigma = inv(sigma);

i=1;
for x1 = rng
    j=1;
    for x2 = rng
        z(j,i) = c*exp( -0.5* ( ([x1 x2]-mu)*inv_sigma*([x1 x2]-mu)' ) );
        j=j+1;
    end
    i=i+1;
end

end
