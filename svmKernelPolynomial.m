function [ value ] = svmKernelPolynomial( x1 , x2 , power , additive_constant )
% SVMKERNELPOLYNOMIAL Calculates the value of a Polynomial Kernel on two
% feature vectors x1 and x2.
%   x1: input vector 1
%   x2: input vector 2
%   power: the degree of the kernel
%   additive_constant: an additive constant under the power

value = (x1*x2' + additive_constant)^power;

end

