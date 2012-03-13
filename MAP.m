function param = map( COV_old , MU_old , X , y , labels , ...
    prior , new )
% MAP: Computes MLE covariances and means for a given training set. One
% covariance matrix and one mean for each class. For MAP it takes prior
% covariances and means into account.
% param = map( COV_old , MU_old , number_old , X , y , labels , prior , new )
%   COV_old: covariances of the prior for each class
%   MU_old: means of the prior for each class
%   X: features to train on
%   y: classes for all training features
%   labels: ordered labels for the classes
%   prior: how relevant each prior covariance and mean is
%   new: how relevant each of the MLE cavariances and means is

% initialzation
COV_new = COV_old;
MU_new = MU_old;
c = length(labels);
n = length(y);
size_X = size(X);
COV_MLE = zeros(size_X(2),size_X(2),c);
MU_MLE = zeros(size_X(2),c);

% compute MLE and MAP
for k = 1 : c
    ind=find(y==labels(k));
    if ~isempty(ind)
        X_k = zeros(length(ind),size_X(2));
        for i = 1 : length(ind)
            X_k(i,:) = X(ind(i),:);
        end
        
        % compute MLE covariance
        if n == 1
            COV_MLE(:,:,k) = eye(size_X(2));
        else
            COV_MLE(:,:,k) = cov(X_k);
        end
        
        % compute MLE mean
        MU_MLE(k,:) = mean(X_k,1);
        
        % check for valid prior covariance
        if COV_old(:,:,k) == 0.*COV_old(:,:,k)
            COV_old(:,:,k) = eye(size_X(2));
            MU_old(k,:) = [0 0];
        end
        
        % compute MAP
        MU_new(k,:) = inv((new(k).*inv(COV_MLE(:,:,k))+prior(k).*inv(COV_old(:,:,k))))*...
            (new(k).*inv(COV_MLE(:,:,k))*MU_MLE(k,:)'+prior(k).*inv(COV_old(:,:,k))*MU_old(k,:)');
        COV_new(:,:,k) = inv(new(k).*inv(COV_MLE(:,:,k))+prior(k).*inv(COV_old(:,:,k)));
    end
end

param = struct('COV', COV_new, 'MU', MU_new, 'labels', labels);

end

