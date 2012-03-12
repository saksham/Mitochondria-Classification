function [ output_args ] = testGrid( input_args )
%TESTGRID Summary of this function goes here
%   Detailed explanation goes here

%Paths
str = strrep(pwd, '/tests', '');
addpath(str);
str = strrep(pwd, '/tests', '/xunit');
addpath(str);

[XBest,BestF,Iters]=grid(2, [0 0], [1 1], [2 2], [1e-4 1e-4], 1e-7, 10000, 'testImageFeatureExtraction')

end

