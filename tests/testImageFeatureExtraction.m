function [ error ] = testImageFeatureExtraction( x )
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
    error = 9999;
    disp(['ERROR: ' num2str(error)]);
    return;
end
disp([num2str(black_percentage) ' : ' num2str(white_percentage)]);

y_vec_struct = load('../data/y_vec.mat');
y_vec = y_vec_struct(1).('y_vec');

images_struct = load('../data/images.mat');
images = images_struct(1).('images');

features = zeros(length(y_vec),2);

for k = 1 : length(y_vec)
    I = images{k};
    
    blobs = blobVector(I , black_percentage , white_percentage);
    
    b = blobs{1};
    cov_b = cov(b);
    if isnan(cov_b)
        error = 9999;
        disp(['ERROR: ' num2str(error)]);
        return;
    end
    
    R = featureExtractionBoundaries(blobs);
    
    n = length(R);
    
    R2 = sum(R(:,1))/n;
    R3 = sum(R(:,2))/n;
    
    features(k,:) = [R2,R3];
end

[SV , error] = svmGetVectorsNoKernel(features,y_vec,0);

disp(['ERROR: ' num2str(error)]);

end

