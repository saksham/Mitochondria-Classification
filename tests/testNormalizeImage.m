function testNormalizeImage
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

%Find sharpest image
sharpness = zeros(1,9);
stacksize = size(stack);
for j=1:stacksize(1,2)
    I = stack(j).('data'); 
    
    % measure the sharpness of original image
    sharpness(1,j) = estimateSharpness(single(I));
    disp(['Sharpness of image ' num2str(j) ' : ' num2str(sharpness(1,j))]);
end

%Normalize
[MAX_i, i] = max(sharpness);
I = stack(i).('data');
eight = normalizeImage(I);
eight_mat = normalizeImageMat(I);

imshow(eight_mat);

%Test for equality
assertEqual(eight, eight_mat);

end

