function [ return_boundaries ] = blobVector( I , black_percentage , white_percentage)
%BLOBVECTOR Summary of this function goes here
%   Detailed explanation goes here

% reduce noise
I = wiener2(I);

% generate histogram
histo_vec = zeros(256,1);
for j = 0 : length(histo_vec)-1
    [r,c,v] = find(I==j);
    histo_vec(j+1) = length(c);
end

% calculate bounds for image adjust
done_black = 0;
done_white = 0;
counter_black = 0;
counter_white = 0;
I_size = size(I);
todo_all = I_size(1,1) * I_size(1,2);
todo_black = black_percentage * todo_all;
todo_white = white_percentage * todo_all;
while done_black < todo_black
    if (done_black + histo_vec(counter_black+1)) > todo_black
        break;
    end
    done_black = done_black + histo_vec(counter_black+1);
    counter_black = counter_black + 1;
end
while done_white < todo_white
    if (done_white + histo_vec(length(histo_vec)-counter_white)) > todo_white
        break;
    end
    done_white = done_white + histo_vec(length(histo_vec)-counter_white);
    counter_white = counter_white + 1;
end
lower_bound = counter_black/256;
upper_bound = (length(histo_vec)-counter_white)/256;
pout_imadjust = imadjust(I,[lower_bound;upper_bound],[0;1],1.0);

% generate a binary image
BW = im2bw(pout_imadjust,0.5);

% generate boundaries
boundaries = bwboundaries(BW);
return_boundaries = cell(1,1);
counter = 0;
for k=1:length(boundaries)
    b = boundaries{k};
    b_size = size(b);
    if b_size(1) > 25 && b_size(1) < 500
        counter = counter + 1;
        return_boundaries{counter} = b;
    end
end

end

