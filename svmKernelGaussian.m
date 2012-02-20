function [ value ] = svmKernelGaussian( x1 , x2 , sigma2 )
%SVMKERNELGAUSSIAN Summary of this function goes here
%   Detailed explanation goes here

value = exp(-norm(x1-x2)^2/(2*sigma2));

end

