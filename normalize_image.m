function [ normalized ] = normalize_image( I )

min_value = min(min(I));
max_value = double(max(max(I)));
max_value = max_value - min_value;
image_size = size(I);
size_x = image_size(1,1);
size_y = image_size(1,2);

normalized = uint8(zeros(size_x,size_y));

for r=1:size_x
    for s=1:size_y
        new_value = uint8((double(I(r,s) - min_value)/double(max_value))*255);
        normalized(r,s) = new_value;
    end
end

end

