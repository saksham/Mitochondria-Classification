function [ overall_error ] = testImageFeatureExtraction( x )
%TESTIMAGEFEATUREEXTRACTION Summary of this function goes here
%   Detailed explanation goes here

%Paths
str = strrep(pwd, '/tests', '');
addpath(str);
str = strrep(pwd, '/tests', '/xunit');
addpath(str);

black_percentage = x(1);
white_percentage = x(2);
if (black_percentage + white_percentage) > 1
    overall_error = 9999;
    disp(['ERROR(constraint): ' num2str(overall_error)]);
    return;
end
disp([num2str(black_percentage) ' : ' num2str(white_percentage)]);

y_vec_struct = load('../data/y_vec.mat');
y_vec = y_vec_struct(1).('y_vec');

images_struct = load('../data/images.mat');
images = images_struct(1).('images');

features = zeros(length(y_vec),2);

overall_error = 0;

%faster
%fast = [1 2 3 4 5 6 7 8 9 10 21 22 23 24 25 26 27 28 29 30];
%y_vec_fast = zeros(length(fast),1);
%features = zeros(length(fast),2);

%for k = 1 : length(fast)
%    I = images{fast(k)};
for k = 1 : length(y_vec)
    I = images{k};
    blobs = blobVector(I , black_percentage , white_percentage);
    
    b = blobs{1};
    cov_b = cov(b);
    if isnan(cov_b)
        %overall_error = overall_error + 1000;
        %disp(['ERROR(image without blobs): +1000']);
        overall_error = 9999;
        disp(['ERROR(image without blobs): ' overall_error]);
        return;
    end
    
    R = featureExtractionBoundaries(blobs);
    
    n = length(R);
    
    R2 = sum(R(:,1))/n;
    R3 = sum(R(:,2))/n;
    
    features(k,:) = [R2,R3];
%    y_vec_fast(k) = y_vec(fast(k));
end


max_x1 = max(features(:,1));
max_x2 = max(features(:,2));
features(:,1) = features(:,1)./max_x1;
features(:,2) = features(:,2)./max_x2;

%[SV , error] = svmGetVectorsNoKernel(features,y_vec_fast,1);
[SV , error] = svmGetVectorsNoKernel(features,y_vec,1);
overall_error = overall_error + error;

disp(['ERROR(overall_error): ' num2str(overall_error)]);

end

