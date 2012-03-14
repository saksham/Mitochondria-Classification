function [ param ] = testNNTrainOnMitochondria( images , y_vec , nn, black_percentage , white_percentage )
%TESTNNTRAINONMITOCHONDRIA Summary of this function goes here
%   Detailed explanation goes here

size_images = size(images);
n = size_images(1);
counter = 0;
I = uint8(zeros(size_images(2),size_images(3)));

for i = 1 : n
    I(:,:) = images(i,:,:);
    blobs = blobVector(I , black_percentage , white_percentage);
    m = length(blobs);
    for k = 1 : m
        counter = counter + 1;
        b = blobs{k};
        B = resizeBlob(b);
        features(counter,:) = B(:);
        y(counter) = y_vec(i);
    end
end

% use same amount of features for each class
ind_1 = find(y==1);
ind_2 = find(y==2);
if length(ind_1) > length(ind_2)
    ind_1 = ind_1(:,1:length(ind_2));
else
    ind_2 = ind_2(:,1:length(ind_1));
end
ind_1_2 = [ind_1 ind_2];

nn = nnTrain(nn, features(ind_1_2,:), y(ind_1_2)', 2, 20);

param = struct('nn', nn, 'black_percentage', black_percentage, 'white_percentage', white_percentage);

end

