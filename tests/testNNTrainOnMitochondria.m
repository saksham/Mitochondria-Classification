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
nn = nnTrain(nn, features, y', 2, 10);

param = struct('nn', nn, 'black_percentage', black_percentage, 'white_percentage', white_percentage);

end

