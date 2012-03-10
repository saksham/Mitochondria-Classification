function [ features ] = imageFeatureExtraction( images , black_percentage , white_percentage )
%IMAGEFEATUREEXTRACTION Summary of this function goes here
%   Detailed explanation goes here

size_images = size(images);
n = size_images(2);
features = zeros(n,2);

for i = 1 : n
   I = images{i};
    blobs = blobVector(I , black_percentage , white_percentage);
    
    b = blobs{1};
    cov_b = cov(b);
    if isnan(cov_b)
        disp(['ERROR: image without blobs']);
        features(i,:) = [NaN,NaN];
        continue;
    end
    
    F = featureExtractionBoundaries(blobs);
    
    n = length(F);
    
    F1 = sum(F(:,1))/n;
    F2 = sum(F(:,2))/n;
    
    features(i,:) = [F1,F2];
end

end

