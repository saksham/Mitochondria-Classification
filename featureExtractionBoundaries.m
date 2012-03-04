function [ F ] = featureExtractionBoundaries( boundaries )
%FEATUREEXTRACTION Summary of this function goes here
%   Detailed explanation goes here

n = length(boundaries);
F = zeros(n,2);
for k=1:n
    b = boundaries{k};
    cov_b = cov(b);
    if isnan(cov_b)
        disp(cov_b);
    end
    [Evector,Evalue] = eig(cov_b);
    big = max(diag(Evalue));
    small = min(diag(Evalue));
    result = small / big;
    circle_error = fuzzyCShells(b') / length(b);
    
    F(k,:) = [result circle_error];
end

end

