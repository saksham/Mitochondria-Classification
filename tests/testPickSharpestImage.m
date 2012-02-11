function testPickSharpestImage
% TESTPICKSHARPESTIMAGE Checks whether or not the sharpest image is
% selected
%
% The sharpest image on the stack: bcis78-2.stk appears to be the 7th
% image. So, this test checks whether or not the estimate sharpness
% function returns the highest value for the image.
%
% See also: ESTIMATESHARPNESS
%
    stack = tiffread2('data/bcis78-2.stk', 1, 1000);
    
    n = size(stack, 2);
    sharpness = zeros(1,n);

    for j=1:n
        I = stack(j).('data'); 
    
        % measure the sharpness of original image
        sharpness(1,j) = estimateSharpness(I);
        %fprintf('\nSharpness of image %f:%f', ...
        %    num2str(j), num2str(sharpness(1,j)));
    end

    [MAX_i, i] = max(sharpness);
    assertEqual(i, 7);
end