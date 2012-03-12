function [ output_args ] = visualizeBlobPrediction( I , blobs , y )
%VISUALIZEBLOBPREDICTION Summary of this function goes here
%   Detailed explanation goes here


figure; imshow(I);
hold on;
labels = [min(y), max(y)];
for i = 1 : length(y)
    if y(i) == labels(1)
        plot(blobs{i}(:,2),blobs{i}(:,1),'g','LineWidth',3);
    else
        plot(blobs{i}(:,2),blobs{i}(:,1),'r','LineWidth',3);
    end
end
hold off;
end

