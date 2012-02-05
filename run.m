[stack, imgread] = tiffread2('../Resources/STK Files/10_bcis78-3.stk', 1, 1000);

threshold = ones(1,9);

max = -Inf;
sharpestImageIndex = 1;
sharpness = zeros(9, 1);
for j=[1, 3, 5, 7, 9, 2, 4, 6, 8]
    image_data = stack(j).('data');
    subplot(3,3,j);
    imshow(uint8(stack(j).('data')));
    title(sprintf('Image %d', j));
    
    sharpness(j) = estimate_sharpness(double(image_data));
    if(sharpness(j) > max)
        max = sharpness(j);
        sharpestImageIndex = j;
    end
end
fprintf('Sharpest image: %d\n', sharpestImageIndex);

figure(2);
imshow(uint8(stack(j).('data')));