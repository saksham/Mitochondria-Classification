function [ F ] = featureExtraction( I )
%FEATUREEXTRACTION Summary of this function goes here
%   Detailed explanation goes here

n = max(max(I));
F = zeros(n,3);
for i = 1 : n
    [r,c,v] = find(I==i);
    M = [c r];
    [Evector,Evalue] = eig(cov(M));
    big = max(diag(Evalue));
    small = min(diag(Evalue));
    result = small / big;
    
    I_copy = zeros(size(I));
    
    for j = 1 : length(c)
        I_copy(c(j),r(j)) = 1;
    end
    I_border = bwperim(I_copy);
    [r,c,v] = find(I_border==1);
    M = [c r];
    circle_error = fuzzyCShells(M');
    
    F(i,:) = [i result circle_error];
end

end

