function [ B ] = resizeBlob( b )
% RESIZEBLOB: Blobs detected in images sometimes have different sizes. To
% use these blobs in an ML programm it is necessary to make them all having
% the same size. This function rescales all input blobs to size 20x20
% pixels.
% [ B ] = resizeBlob( b )
%   b: boundaries of one single blob

% find bounds and dimensions of original blob
min_b = min(b);
max_b = max(b);
min_x = min_b(1);
min_y = min_b(2);
max_x = max_b(1);
max_y = max_b(2);
range_x = max_x - min_x;
range_y = max_y - min_y;
size_b = size(b);

% shift the blob towards (0,0)
sub = ones(size_b(1),2);
for i = 1 : size_b(1)
    sub(i,:) = [min_x-1 min_y-1];
end
b = b - sub;

% calculate a quadratic frame around each blob and center the blob in it
range = 0;
margin_x = 0;
margin_y = 0;
if range_x > range_y
    range = range_x;
    diff = range_x - range_y;
    margin_y = floor(diff / 2);
else
    range = range_y;
    diff = range_y - range_x;
    margin_x = floor(diff / 2);
end

% 'print out' blob to a new image matrix
B = zeros(range+1,range+1);
for i = 1 : size_b(1)
    B(b(i,1)+margin_x,b(i,2)+margin_y) = 1;
end

% resizing
B = imresize(B,[20 20]);
B = im2bw(B,0.5);

end

