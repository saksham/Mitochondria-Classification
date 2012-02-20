function [ output_args ] = testSVMGetVectorsNoKernel( input_args )
%TESTSVMGETVECTORSNOKERNEL Summary of this function goes here
%   Detailed explanation goes here

%Paths
str = strrep(pwd, '/tests', '');
addpath(str);
str = strrep(pwd, '/tests', '/xunit');
addpath(str);

X = [0 0 ; 1 0 ; 0 1 ; 1 1 ; 0.3 0.3 ; 0.9 0.9];
y = [-1 ; -1 ; -1 ; 1 ; 1 ; 1];

SV = svmGetVectorsNoKernel(X,y,1);

%assertEqual(SV, [0 0 ; 1 0 ; 0 1]);

end

