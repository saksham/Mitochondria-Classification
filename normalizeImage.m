function [ normalized ] = normalizeImage( I )
% NORMALIZEIMAGE: Normalizese an uint16 grayscale image to an uint8 image. 
% The reasons are speed and memory improvements while the quality is still 
% good enought for mitochondria classification.
% [ normalized ] = normalizeImage( I )
%   I: image to be normalized

% find min and max and calculate the original range
min_value = double(min(min(I)));
max_value = double(max(max(I)));
range = double(max_value - min_value);

% normalize
normalized = uint8((double(I) - min_value) / range * 255);

end
