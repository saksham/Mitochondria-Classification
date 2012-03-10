function [ overall_error ] = testImageFeatureExtraction( x )
%TESTIMAGEFEATUREEXTRACTION Summary of this function goes here
%   Detailed explanation goes here

%Paths
str = strrep(pwd, '/tests', '');
addpath(str);
str = strrep(pwd, '/tests', '/xunit');
addpath(str);

black_percentage = x(1);
white_percentage = x(2);
if (black_percentage + white_percentage) > 1
    overall_error = 100;
    disp(['ERROR(constraint): ' num2str(overall_error)]);
    return;
end
disp([num2str(black_percentage) ' : ' num2str(white_percentage)]);

y_vec_struct = load('../data/y_vec.mat');
y_vec = y_vec_struct(1).('y_vec');

images_struct = load('../data/images.mat');
images = images_struct(1).('images');

features = zeros(length(y_vec),2);

overall_error = 0;

%faster
%fast = [1 2 3 4 5 6 7 8 9 10 21 22 23 24 25 26 27 28 29 30];
%y_vec_fast = zeros(length(fast),1);
%features = zeros(length(fast),2);

%for k = 1 : length(fast)
%    I = images{fast(k)};
for k = 1 : length(y_vec)
    I = images{k};
    blobs = blobVector(I , black_percentage , white_percentage);
    
    b = blobs{1};
    cov_b = cov(b);
    if isnan(cov_b)
        %overall_error = overall_error + 1000;
        %disp(['ERROR(image without blobs): +1000']);
        overall_error = 100;
        disp(['ERROR(image without blobs): ' num2str(overall_error)]);
        return;
    end
    
    R = featureExtractionBoundaries(blobs);
    
    n = length(R);
    
    R2 = sum(R(:,1))/n;
    R3 = sum(R(:,2))/n;
    
    features(k,:) = [R2,R3];
    %    y_vec_fast(k) = y_vec(fast(k));
    %[COV , MU] = MAP( COV , MU , k-1 , [R2,R3] , y_vec(k) , [-1 , 1]);
end

max_x1 = max(features(:,1));
max_x2 = max(features(:,2));
features(:,1) = features(:,1)./max_x1;
features(:,2) = features(:,2)./max_x2;


COV = zeros(2,2,2);
COV(1,1,1) = 0.01;
COV(2,2,1) = 0.01;
COV(1,1,2) = 0.01;
COV(2,2,2) = 0.01;
MU = zeros(2,2);
[COV , MU] = MAP( COV , MU , k-1 , features , y_vec , [-1 , 1] , [0 0] , [1 1]);

y_pred = mapPredict(COV , MU , [-1 , 1] , features);


hold on;
for i = 1 : length(y_pred)
    if y_pred(i) == y_vec(i)
        continue;
    end
    scatter(features(i,1),features(i,2),'+','blue');
end

trainingSetAccuracy = mean(double(y_pred == y_vec)) * 100;

overall_error = 100 - trainingSetAccuracy;

[x,y,z] = evalF(1,MU(1,:),COV(:,:,1));
contour(x,y,z,1,'green');
[x,y,z] = evalF(1,MU(2,:),COV(:,:,2));
contour(x,y,z,1,'red');


% 
% COV = zeros(2,2,2);
% COV(1,1,1) = 0.01;
% COV(2,2,1) = 0.01;
% COV(1,1,2) = 0.01;
% COV(2,2,2) = 0.01;
% MU = zeros(2,2);
% [COV , MU] = MAP( COV , MU , k-1 , features , y_vec , [-1 , 1] , [1 1] , [1 1]);
% [x,y,z] = evalF(1,MU(1,:),COV(:,:,1));
% contour(x,y,z,1,'green');
% [x,y,z] = evalF(1,MU(2,:),COV(:,:,2));
% contour(x,y,z,1,'red');
% 
% COV = zeros(2,2,2);
% COV(1,1,1) = 0.01;
% COV(2,2,1) = 0.01;
% COV(1,1,2) = 0.01;
% COV(2,2,2) = 0.01;
% MU = zeros(2,2);
% [COV , MU] = MAP( COV , MU , k-1 , features , y_vec , [-1 , 1] , [0.5 0.5] , [1 1]);
% [x,y,z] = evalF(1,MU(1,:),COV(:,:,1));
% contour(x,y,z,1,'green');
% [x,y,z] = evalF(1,MU(2,:),COV(:,:,2));
% contour(x,y,z,1,'red');
% 
% COV = zeros(2,2,2);
% COV(1,1,1) = 0.01;
% COV(2,2,1) = 0.01;
% COV(1,1,2) = 0.01;
% COV(2,2,2) = 0.01;
% MU = zeros(2,2);
% [COV , MU] = MAP( COV , MU , k-1 , features , y_vec , [-1 , 1] , [1 1] , [0 0]);
% [x,y,z] = evalF(1,MU(1,:),COV(:,:,1));
% contour(x,y,z,1,'green');
% [x,y,z] = evalF(1,MU(2,:),COV(:,:,2));
% contour(x,y,z,1,'red');

for i = 1 : length(y_vec)
    if y_vec(i) == 1
        scatter(features(i,1),features(i,2),'X','red');
    else
        scatter(features(i,1),features(i,2),'O','green');
    end
end
axis([0 1 0 1]);



%[SV , error] = svmGetVectorsNoKernel(features,y_vec_fast,1);
%[SV , error] = svmGetVectorsNoKernel(features,y_vec,1);
%overall_error = overall_error + error;

disp(['ERROR(overall_error): ' num2str(overall_error)]);


end

function [x,y,z] = evalF(c,mu,sigma)

rng = 0:.01:1;
[x,y] = meshgrid(rng,rng);
z = zeros(numel(rng),numel(rng));
inv_sigma = inv(sigma);

i=1;
for x1 = rng
    j=1;
    for x2 = rng
        z(j,i) = c*exp( -0.5* ( ([x1 x2]-mu)*inv_sigma*([x1 x2]-mu)' ) );
        j=j+1;
    end
    i=i+1;
end

end
