function [ features ] = imageFeatureExtraction( images , black_percentage , white_percentage )
% IMAGEFEATUREEXTRACTION: Takes an image gets all the valid blobs and 
% extracts the features 'covariance proportion' and 'cicularity' from them.
% The two normalized features will be returned for each image.
% [ features ] = imageFeatureExtraction( images , black_percentage , white_percentage )
%   images: images to process
%   black_percentage: percentage of dark pixels of the image that go to 0
%   after image adjustment
%   white_percentage: percentage of light pixels of the image that go to 1
%   after image adjustment

size_images = size(images);
n = size_images(2);
features = zeros(n,2);

% process images one by one
for i = 1 : n
    I = images{i};
    
    % detect blobs (mitochondria)
    blobs = blobVector(I , black_percentage , white_percentage);

    % continue only with images having at least one blob
    b = blobs{1};
    cov_b = cov(b);
    if isnan(cov_b)
        disp(['ERROR: image without blobs']);
        features(i,:) = [NaN,NaN];
        continue;
    end
    
    % get features
    F = featureExtractionBoundaries(blobs);
    
    % average for each image
    n = length(F);
    F1 = sum(F(:,1))/n;
    F2 = sum(F(:,2))/n;
    
    features(i,:) = [F1,F2];
end

% normalize features to range [0,1]
max_x1 = max(features(:,1));
max_x2 = max(features(:,2));
min_x1 = min(features(:,1));
min_x2 = min(features(:,2));
% 'covariance proportion'   0: eigenvalues are hightly different
%                           1: eigenvalues are equal
features(:,1) = (features(:,1)-min_x1)./(max_x1-min_x1);
% 'circularity'             0: line shaped
%                           1: circle shaped
features(:,2) = 1-(features(:,2)-min_x2)./(max_x2-min_x2);

end

