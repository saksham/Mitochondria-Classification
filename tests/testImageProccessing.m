function testImageProccessing
%Test if matrix normalization will lead to the same result
%than element wise normalization

%Paths
str = strrep(pwd, '/tests', '');
addpath(str);
str = strrep(pwd, '/tests', '/xunit');
addpath(str);

%Clean up
clear; close all; clc;

%Load example image data
stack = load('../data/bcis78.mat');
stack = stack.('stack');

I = stack(8).('data');
I = normalizeImageMat(I);

[junk threshold] = edge(I, 'sobel');
fudgeFactor = 1;
BWs = edge(I,'sobel', threshold * fudgeFactor);
%figure, imshow(BWs), title('binary gradient mask');
se90 = strel('line', 30, 90);
se45 = strel('line', 30, 45);
se0 = strel('line', 30, 0);
BWsdil = imdilate(BWs, [se90 se45 se0]);
%figure, imshow(BWsdil), title('dilated gradient mask');
BWdfill = imfill(BWsdil, 'holes');
%figure, imshow(BWdfill);
%title('binary image with filled holes');
seD = strel('diamond',1);
%BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWdfill,seD);
%figure, imshow(BWfinal), title('segmented image');
BWoutline = bwperim(BWfinal);
Segout = I;
Segout(BWoutline) = 255;
%figure, imshow(Segout), title('outlined original image');

image_size = size(BWoutline);

row = 1;
for i = 1 : image_size(2)
    for j = 1 : image_size(1)
        if BWoutline(j,i) == 1
            M(row,:) = [i,j];
            row = row + 1;
        end
    end
    disp(num2str(i));
end

[PC,V] = eig(cov(M));

V = diag(V);
% sort the variances in decreasing order 
[junk, rindices] = sort(-1*V);
V = V(rindices);
PC = PC(:,rindices);
% project the original data set 
rM = M * PC;

MTEST = [1 1];
rMTEST = MTEST * PC;

a = rMTEST(1,1);
b = rMTEST(1,2);

alpha = (tan(abs(a)/abs(b)))*180/pi+45;

rBWdfill = imrotate(I,alpha,'bilinear','crop');

figure, imshow(I);
figure, scatter(M(:,1),-M(:,2),'X');
figure, imshow(rBWdfill);
figure, scatter(rM(:,1),-rM(:,2),'X');

end



