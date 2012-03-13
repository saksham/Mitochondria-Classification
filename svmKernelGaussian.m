function [ value ] = svmKernelGaussian( x1 , x2 , sigma2 )
% SVMKERNELGAUSSIAN Calculates the value of a Gaussion Kernel on two
% feature vectors x1 and x2.
%   x1: input vector 1
%   x2: input vector 2
%   sigma2: variance

value = exp(-norm(x1-x2)^2/(2*sigma2));

end

