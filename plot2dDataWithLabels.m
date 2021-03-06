function plot2dDataWithLabels(X, y)
%PLOTDATA2DWITHLABELS Plots the data points X and y into a new figure 
%   PLOTDATAWITHLABELS(x,y) plots the data points with + for the positive 
%   examples and o for the negative examples. X is assumed to be a Mx2 
%   matrix.

% Create New Figure
figure; hold on;

labels = [min(y), max(y)];
pos = find(y == labels(2)); neg = find(y == labels(1));

plot(X(pos, 1), X(pos, 2), 'k+', 'LineWidth', 2, 'MarkerSize', 7);
plot(X(neg, 1), X(neg, 2), 'ko', 'MarkerFaceColor', 'y', 'MarkerSize', 7);

hold off;

end