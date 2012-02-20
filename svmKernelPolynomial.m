function [ value ] = svmKernelPolynomial( x1 , x2 , power , additive_constant )
%SVMKERNELPOLYNOMIAL Summary of this function goes here
%   Detailed explanation goes here

value = (x1*x2' + additive_constant)^power;

end

