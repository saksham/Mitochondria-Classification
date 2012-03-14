function [ y_pred ] = testNNPredictOnMitochondria( images , param )
%TESTNNPREDICTONMITOCHONDRIA Summary of this function goes here
%   Detailed explanation goes here

nn = param.('nn');
black_percentage = param.('black_percentage');
white_percentage = param.('white_percentage');
layer_sizes = nn.('layer_sizes');
size_images = size(images);
n = size_images(1);
I = uint8(zeros(size_images(2),size_images(3)));

y_pred = zeros(n,1);
for i = 1 : n
    I(:,:) = images(i,:,:);
    blobs = blobVector(I , black_percentage , white_percentage);
    m = length(blobs);
    new_features = zeros(m,layer_sizes(1));
    for k = 1 : m
        B = resizeBlob(blobs{k});
        new_features(k,:) = B(:);
    end
    y_pred_image = nnPredict(nn, new_features);
    result = sum(y_pred_image);
    %disp(num2str(result/m));
    if(result/m < 1.5)
        y_pred(i) = 1;
    else
        y_pred(i) = 2;
    end
    % Plot
    %visualizeBlobPrediction(I, blobs, y_pred_image);
end

end

