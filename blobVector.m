function [ return_boundaries ] = blobVector( I , black_percentage , white_percentage)
% BLOBVECTOR: Calculates the boundaries of mitochondria.
% [ return_boundaries ] = blobVector( I , black_percentage , white_percentage)
% Reduces noise and adjusts contrast of the image. Generate a binary image
% and compute blob boundaries from it.
%   I: image to be computed
%   black_percentage: how many of the dark pixels should go to 0
%   white_percentage: how many of the bright pixels go to 1

% reduce noise
I = wiener2(I);

% generate histogram
data = I(:);
histo_vec = histc(data,[0:255]);

% plot histogram
%figure; hist(double(data),[0:255]);
%axis([0 255 0 max(histo_vec)+100]);

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
pout_imadjust = imadjust(I,[lower_bound;upper_bound],[0;1]);

% generate a binary image
BW = im2bw(pout_imadjust,0.5);

% generate boundaries
boundaries = bwboundaries(BW);
return_boundaries = cell(1,1);
counter = 0;

% select boundaries that represent mitochondria
% throw away blobs that are to big or to small
for k=1:length(boundaries)
    b = boundaries{k};
    b_size = size(b);
    if b_size(1) > 25 && b_size(1) < 500
        counter = counter + 1;
        return_boundaries{counter} = b;
    end
end

% plot boundaries on binary image
% imshow(BW);
% hold on;
% for i = 1 : length(return_boundaries)
%     plot(return_boundaries{i}(:,2),return_boundaries{i}(:,1),'g','LineWidth',2);
% end

end

