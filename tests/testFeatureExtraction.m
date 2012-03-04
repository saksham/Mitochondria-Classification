function [ output_args ] = testFeatureExtraction( input_args )
%TESTFEATUREEXTRACTION Summary of this function goes here
%   Detailed explanation goes here

%Paths
str = strrep(pwd, '/tests', '');
addpath(str);
str = strrep(pwd, '/tests', '/xunit');
addpath(str);

%Clean up
clear; close all; clc;

S1 = zeros(10,11);
S1(3,4:5) = 1;
S1(4,3:6) = 1;
S1(5,2:7) = 1;
S1(6,2:7) = 1;
S1(7,3:6) = 1;
S1(8,4:5) = 1;

S2 = zeros(10,11);
S2(2,5:6) = 1;
S2(3,5) = 1;
S2(4,4:5) = 1;
S2(5,3) = 1;
S2(6,2:3) = 1;
S2(7,1) = 1;

S3 = zeros(10,11);
S3(2,5:6) = 1;
S3(3,5) = 1;
S3(4,4:5) = 1;
S3(5,3) = 1;
S3(6,2:3) = 1;
S3(7,1) = 1;
S3(4,6:7) = 2;
S3(5,5:8) = 2;
S3(6,5:8) = 2;
S3(7,6:7) = 2;
S3(2,7) = 3;
S3(3,7:8) = 3;
S3(4,8:10) = 3;

%R1 = featureExtraction(S1);
%R2 = featureExtraction(S2);
R3 = featureExtraction(S3);

end

