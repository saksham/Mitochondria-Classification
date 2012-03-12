function [ B ] = resizeBlob( b )
%RESIZEBLOB Summary of this function goes here
%   Detailed explanation goes here

min_b = min(b);
max_b = max(b);
min_x = min_b(1);
min_y = min_b(2);
max_x = max_b(1);
max_y = max_b(2);
range_x = max_x - min_x;
range_y = max_y - min_y;
size_b = size(b);
sub = ones(size_b(1),2);
for i = 1 : size_b(1)
    sub(i,:) = [min_x-1 min_y-1];
end
b = b - sub;
B = zeros(range_x+1,range_y+1);
for i = 1 : size_b(1)
    B(b(i,1),b(i,2)) = 1;
end
B = imresize(B,[20 20]);
B = im2bw(B,0.5);

end

