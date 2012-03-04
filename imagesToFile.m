function [  ] = imagesToFile( path_class_1 , path_class_2 )
%TESTIMAGEFEATUREEXTRACTION Summary of this function goes here
%   Detailed explanation goes here

% Paths
str = strrep(pwd, '/tests', '');
addpath(str);
str = strrep(pwd, '/tests', '/xunit');
addpath(str);

% load images
%path_c = '../../../data/Circle';
list_class_1 = dir(path_class_1);
files_class_1 = {list_class_1.name};
%path_l = '../../../data/Lines';
list_class_2 = dir(path_class_2);
files_class_2 = {list_class_2.name};

% sample targets
y_vec = zeros(numel(files_class_1)-3+numel(files_class_2)-3,1);

images = cell(1,1);
for u = 1 : 2
    
    path = '';
    files = NaN;
    y = 0;
    offset = 0;
    
    if u == 1
        path = path_class_1;
        files = files_class_1;
        y = 1;
    elseif u == 2
        path = path_class_2;
        files = files_class_2;
        y = -1;
        offset = numel(files_class_1)-3;
    end
    
    for k = 4 : numel(files)
        
        disp(['Working on: ' files{k}]);
        
        [stack, imgread] = tiffread2(fullfile(path,files{k}), 1, 1000);
        
        % find sharpest image
        n = size(stack, 2);
        sharpness = zeros(1,n);
        for j=1:n
            I = stack(j).('data');
            % measure the sharpness of original image
            sharpness(1,j) = estimateSharpness(I);
        end
        [MAX_i, i] = max(sharpness);
        
        I = stack(i).('data');
        I = normalizeImageMat(I);
        
        % resize to improve speed
        I = imresize(I, 0.5);
        
        images{k-3+offset} = I;
        y_vec(k-3+offset) = y;
    end
end
% save images and sample targets
save('../data/images','images');
save('../data/y_vec','y_vec');
end

