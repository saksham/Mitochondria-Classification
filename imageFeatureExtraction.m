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

max_x1 = max(features(:,1));
max_x2 = max(features(:,2));
min_x1 = min(features(:,1));
min_x2 = min(features(:,2));
features(:,1) = (features(:,1)-min_x1)./(max_x1-min_x1);
features(:,2) = 1-(features(:,2)-min_x2)./(max_x2-min_x2);

end

