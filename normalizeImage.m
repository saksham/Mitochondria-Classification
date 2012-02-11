function [ normalized ] = normalizeImage( I )
%NORMALIZEIMAGE normalizes the image to 0-255 range
% [normalized] = normalizeImage(I)
%

min_value = double(min(min(I)));
max_value = double(max(max(I)));
range = double(max_value - min_value);

normalized = uint8((double(I) - min_value) / range * 255);

end
