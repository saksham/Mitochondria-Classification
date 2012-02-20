function [signals,PC,V] = pPCA(data , limit)
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
V = V(rindices);
PC = PC(:,rindices);
% only use the 'best' vectors
PC = PC(:,1:limit);
% project the original data set 
signals = data * PC;
end