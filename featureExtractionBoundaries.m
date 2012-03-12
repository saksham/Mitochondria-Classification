function [ F ] = featureExtractionBoundaries( boundaries )
% FEATUREEXTRACTIONBOUNDARIES: Extracts eigenvalue proportion and 
% circularity from given boundaries.
% [ F ] = featureExtractionBoundaries( boundaries )
% Finds the largest eigenvalues of each blob and calculate there proportion
% to each other to get the first feature. The second feature is the summed
% error of each distance between a pixel and a perfect circle.
%   boundaries: vector containing the boundaries for that the features will
%               be calculated

n = length(boundaries);
F = zeros(n,2);
for k=1:n
    b = boundaries{k};
    
    % find eigenvalues of the covariance
    cov_b = cov(b);
    if isnan(cov_b)
        disp(cov_b);
    end
    [Evector,Evalue] = eig(cov_b);
    
    % compare eigenvalues
    big = max(diag(Evalue));
    small = min(diag(Evalue));
    result = small / big;
    
    % calculate the error that describes how far the blob is to be a
    % perfect circle
    circle_error = fuzzyCShells(b') / length(b);
    
    F(k,:) = [result circle_error];
end

end

