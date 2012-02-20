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

X = [0 0 ; 1 0 ; 0.5 -0.5 ; 1 1 ; 0.9 0.9 ; 0.3 0.3];
y = [-1 ; -1 ; -1 ; 1 ; 1 ; 1];

% use this to generate the supportvectors of the original data set
[SV_X , SV_y] = svmGetVectorsKernel(X,y,1,10,'gauss',0.2,0);

% use this to classify new data only using the support vectors
new_y = svmClassifier(SV_X,SV_y,[-0.2 -0.2 ; -0.1 0.5],10,'gauss',0.2,0);

assertEqual(new_y , [-1 ; 1]);

end

