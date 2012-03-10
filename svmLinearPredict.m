function [ new_y ] = svmLinearPredict( W , b , new_X )
%SVMLINEARPREDICT Summary of this function goes here
%   Detailed explanation goes here

size_X = size(new_X);
n = size_X(1);
new_y = zeros(n,1);

for i = 1 : n
    if (W' * new_X(i,:)' + b) > 0
        new_y(i) = 1;
    else
        new_y(i) = -1;
    end
end

end

