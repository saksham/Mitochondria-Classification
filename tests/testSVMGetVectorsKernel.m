function [ output_args ] = testSVMGetVectorsNoKernel( input_args )
%TESTSVMGETVECTORSNOKERNEL Summary of this function goes here
%   Detailed explanation goes here

%Clean up
clear; close all; clc;

%Paths
str = strrep(pwd, '/tests', '');
addpath(str);
str = strrep(pwd, '/tests', '/xunit');
addpath(str);
str = strrep(pwd, '/tests', '/data');
addpath(str);

% X = [0 0 ; 1 0 ; 0.5 -0.5 ; 1 1 ; 0.9 0.9 ; 0.3 0.3];
% y = [-1 ; -1 ; -1 ; 1 ; 1 ; 1];
% 
% % use this to generate the supportvectors of the original data set
% [SV_X , SV_y] = svmGetVectorsKernel(X,y,1,10,'gauss',0.2,0);
% 
% % use this to classify new data only using the support vectors
% new_y = svmClassifier(SV_X,SV_y,[-0.2 -0.2 ; -0.1 0.5],10,'gauss',0.2,0);
% 
% assertEqual(new_y , [-1 ; 1]);

load('data/ml-class_ex4data1.mat');

% do a little pPCA to reduce the amount of parameters from 400 to only 10
X = pPCA(X,10);

% multi class is too difficult ;-)
% thats only predict for '3' for testing
% train on 100 samples
n = length(y);
y_next = zeros(100,1);
X_next = zeros(100,10);
for i = 1 : 50
    if y(i*50) == 3
        y_next(i) = 1;
    else
        y_next(i) = -1;
    end
    X_next(i,:) = X(i*50,:);
end

[SV_X , SV_y] = svmGetVectorsKernel(X_next,y_next,0,10,'gauss',1,0);

% predict for 50 samples
n = length(y);
y_next = zeros(50,1);
X_next = zeros(50,10);
for i = 1 : 50
    if y(i*100-3) == 3
        y_next(i) = 1;
    else
        y_next(i) = -1;
    end
    X_next(i,:) = X(i*100-3,:);
end

pred = svmClassifier(SV_X,SV_y,X_next,10,'gauss',1,0);

trainingSetAccuracy = mean(double(pred == y_next)) * 100;
assert(trainingSetAccuracy > 93, 'Training set accuracy should be ~95%');

end

