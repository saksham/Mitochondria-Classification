function [ normalized ] = normalize_image_mat( I )

min_value = min(min(I));
max_value = double(max(max(I)));
max_value = max_value - min_value;

I = (double(I - min_value ) ./ double(max_value)).*255;
normalized = uint8(I);

end

