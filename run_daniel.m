[stack, imgread] = tiffread2('bcis78.stk', 1, 1000);

sharpness = zeros(1,9);
stacksize = size(stack);

for j=1:stacksize(1,2)
    I = stack(j).('data'); 
    
    % measure the sharpness of original image
    sharpness(1,j) = estimate_sharpness(I);
    disp(['Sharpness of image ' num2str(j) ' : ' num2str(sharpness(1,j))]);
end

[MAX_i, i] = max(sharpness);

I = stack(i).('data');
eight = normalize_image(I);
imshow(eight);