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

C = 150;
feature_accuracy = 0.7;
sigma = 1;

% do a little PCA to reduce the amount of parameters from 400 to only 10
[X , features] = PCA(X,feature_accuracy);

% multi class is too difficult ;-)
% thats only predict for '3' for testing
% train on 475 samples
% 250 - not 3
% 225 - 3
y_next = zeros(475,1);
X_next = zeros(475,features);
X_next(1:25,:) = X(1:25,:);         %10
X_next(26:50,:) = X(501:525,:);     %1
X_next(51:75,:) = X(1001:1025,:);   %2
X_next(76:100,:) = X(2001:2025,:);  %4
X_next(101:125,:) = X(2501:2525,:); %5
X_next(126:150,:) = X(3001:3025,:); %6
X_next(151:175,:) = X(3501:3525,:); %7
X_next(176:200,:) = X(4001:4025,:); %8
X_next(201:225,:) = X(4501:4525,:); %9
X_next(226:475,:) = X(1501:1750,:); %3
y_next(1:225) = -1;
y_next(226:475) = 1;


[SV_X , SV_y , alpha] = svmGetVectorsKernel(X_next,y_next,0,C,'gauss',sigma,0);

% test on 475 samples
% 250 - not 3
% 225 - 3
y_next = zeros(475,1);
X_next = zeros(475,features);
X_next(1:25,:) = X(26:50,:);         %10
X_next(26:50,:) = X(526:550,:);     %1
X_next(51:75,:) = X(1026:1050,:);   %2
X_next(76:100,:) = X(2026:2050,:);  %4
X_next(101:125,:) = X(2526:2550,:); %5
X_next(126:150,:) = X(3026:3050,:); %6
X_next(151:175,:) = X(3526:3550,:); %7
X_next(176:200,:) = X(4026:4050,:); %8
X_next(201:225,:) = X(4526:4550,:); %9
X_next(226:475,:) = X(1751:2000,:); %3
y_next(1:225) = -1;
y_next(226:475) = 1;

pred = svmClassifier(SV_X,SV_y,alpha,X_next,'gauss',sigma,0);

trainingSetAccuracy = mean(double(pred == y_next)) * 100;
assert(trainingSetAccuracy > 90, 'Training set accuracy should be ~90%');

end

