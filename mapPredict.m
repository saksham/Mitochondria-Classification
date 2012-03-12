function [ y_pred ] = mapPredict( COV , MU , labels , X )
%MAPPREDICT Summary of this function goes here
%   Detailed explanation goes here

size_X = size(X);
n = size_X(1);
y_pred = zeros(n,1);
c = length(labels);

for i = 1 : n
    results = zeros(c,1);
    for k = 1 : c
        results(k) = 1/sqrt(det(2*pi*COV(:,:,k))) * ...
            exp(-(1/2)*(X(i,:)-MU(k,:))/(COV(:,:,k))*(X(i,:)-MU(k,:))');
    end
    [C , I] = max(results);
    y_pred(i) = labels(I);
end

end

