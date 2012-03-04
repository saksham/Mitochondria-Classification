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
%stack = load('../data/bcis78.mat');
%stack = stack.('stack');

%I = stack(8).('data');

[stack, imgread] = tiffread2('../../../data/Tubular/age-12.stk', 1, 1000);


n = size(stack, 2);
sharpness = zeros(1,n);

for j=1:n
    I = stack(j).('data');
    
    % measure the sharpness of original image
    sharpness(1,j) = estimateSharpness(I);
    %fprintf('\nSharpness of image %f:%f', ...
    %    num2str(j), num2str(sharpness(1,j)));
end

[MAX_i, i] = max(sharpness);

I = stack(i).('data');
I = normalizeImageMat(I);

I = wiener2(I);

histo_vec = zeros(256,1);

for j = 0 : length(histo_vec)-1
    [r,c,v] = find(I==j);
    histo_vec(j+1) = length(c);
end

done_black = 0;
done_white = 0;
counter_black = 0;
counter_white = 0;
while done_black < 1045590
    done_black = done_black + histo_vec(counter_black+1);
    counter_black = counter_black + 1;
end
while done_white < 4678
    done_white = done_white + histo_vec(length(histo_vec)-counter_white);
    counter_white = counter_white + 1;
end
lower_bound = counter_black/256;
upper_bound = (length(histo_vec)-counter_white)/256;

imtool(I);

pout_imadjust = imadjust(I,[lower_bound;upper_bound],[0;1],1.0);

%x = 0:1:255;
%hist(I,x);

%figure; imshow(I);
figure; imshow(pout_imadjust);

BW = im2bw(pout_imadjust,0.5);
imshow(BW);

%BW_filled = imfill(BW,'holes');
boundaries = bwboundaries(BW);
%imshow(BW_filled);


hold on;
counter_black = 0;
for k=1:length(boundaries)
    b = boundaries{k};
    b_size = size(b);
    if b_size(1) > 50 && b_size(1) < 1000
        plot(b(:,2),b(:,1),'g','LineWidth',2);
        counter_black = counter_black +1;
    end
end
disp(num2str(counter_black));

%imshow(I)
%hold on;
%plot(boundary(:,2),boundary(:,1),'g','LineWidth',3);




% size_I = size(I);
%
% [junk threshold] = edge(I, 'sobel');
% fudgeFactor = 1;
% BWs = edge(I,'sobel', threshold * fudgeFactor);
% %figure, imshow(BWs), title('binary gradient mask');
% se90 = strel('line', 30, 90);
% se45 = strel('line', 30, 45);
% se0 = strel('line', 30, 0);
% BWsdil = imdilate(BWs, [se90 se45 se0]);
% %figure, imshow(BWsdil), title('dilated gradient mask');
% BWdfill = imfill(BWsdil, 'holes');
% %figure, imshow(BWdfill);
% %title('binary image with filled holes');
% seD = strel('diamond',1);
% %BWfinal = imerode(BWnobord,seD);
% BWfinal = imerode(BWdfill,seD);
% %figure, imshow(BWfinal), title('segmented image');
% BWoutline = bwperim(BWfinal);
% Segout = I;
% Segout(BWoutline) = 255;
% %figure, imshow(Segout), title('outlined original image');
%
% for y = 1 : size_I(1)
%     active = 0
%     for x = 1 : size_I(2)
%         if BWoutline(y,x) == 1 && active == 0
%             active = 1;
%         elseif BWoutline(y,x) == 1 && active == 1 && x<size_I(2) && BWoutline(y,x+1) == 0
%             active = 0;
%         elseif active == 0
%             I(y,x) = 0;
%         end
%     end
% end
%
% figure, imshow(I);
%
%
%
%
% [r,c,v] = find(BWoutline==1);
% M = [c r];
%
% [PC,V] = eig(cov(M));
%
% V = diag(V);
% % sort the variances in decreasing order
% [junk, rindices] = sort(-1*V);
% V = V(rindices);
% PC = PC(:,rindices);
% % project the original data set
% rM = M * PC;
%
% MTEST = [1 1];
% rMTEST = MTEST * PC;
%
% a = rMTEST(1,1);
% b = rMTEST(1,2);
%
% alpha = (tan(abs(a)/abs(b)))*180/pi+45;
%
% r_I = imrotate(I,alpha,'bilinear','crop');
%
% negImage = double(r_I);
% negImageScale = 1.0/max(negImage(:));
% negImage = 1 - negImage*negImageScale;
%
%
%
% %figure, imshow(I);
% %figure, scatter(M(:,1),-M(:,2),'X');
% figure, imshow(negImage);
% %figure, scatter(rM(:,1),-rM(:,2),'X');

end



