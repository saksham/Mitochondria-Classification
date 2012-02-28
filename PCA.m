function [signals,i] = PCA(data , accuracy)
% PCA1: Perform PCA using covariance. 
% data - MxN matrix of input data
% (M dimensions, N trials)
% signals - MxN matrix of projected data
% PC - each column is a PC
% V - Mx1 matrix of variances
[M,N] = size(data);
% subtract off the mean for each dimension 
mn = mean(data,1);
data = data - repmat(mn,M,1);
% calculate the covariance matrix 
covariance = cov(data);
% find the eigenvectors and eigenvalues 
[PC, V] = eig(covariance);
% extract diagonal of matrix as vector
V = diag(V);
% sort the variances in decreasing order 
[junk, rindices] = sort(-1*V);
sum_all = sum(V);
sum_best = 0.0;
i = 0;
while (sum_best / -sum_all) < accuracy
    i = i+1;
    sum_best = sum_best + junk(i);
end
    
%V = V(rindices);
PC = PC(:,rindices);
% only use the 'best' vectors
PC = PC(:,1:i);
% project the original data set 
signals = data * PC;
end