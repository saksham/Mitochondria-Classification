function visualize2dLinearBoundary(X, y, theta)
%VISUALIZE2DLINEARBOUNDARY Plots the data points X and y into a new figure with
%the decision boundary defined by theta
%   VISUALIZE2DLINEARBOUNDARY(X, y, theta) plots the data points with + for 
%   the positive examples and o for the negative examples. X is assumed to 
%   be either
%   1) Mx3 matrix, where the first column is an all-ones column for the 
%      intercept.
%   2) MxN, N>3 matrix, where the first column is all-ones

% Plot Data
plot2dDataWithLabels(X(:,2:3), y);
hold on

% Only need 2 points to define a line, so choose two endpoints
plot_x = [min(X(:,2))-2,  max(X(:,2))+2];

% Calculate the decision boundary line
plot_y = (-1./theta(3)).*(theta(2).*plot_x + theta(1));

% Plot, and adjust axes for better viewing
plot(plot_x, plot_y)

xlabel('\sigma_r','fontsize',14);
ylabel('circularity','fontsize',14);
legend('Fragmented', 'Tubular', 'Decision Boundary','Location','NorthOutside','Orientation','horizontal')
end