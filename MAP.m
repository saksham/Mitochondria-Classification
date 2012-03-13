function param = MAP( COV_old , MU_old , number_old , X , y , labels , ...
    prior , new )
%MAP Summary of this function goes here
%   Detailed explanation goes here

COV_new = COV_old;
MU_new = MU_old;

c = length(labels);
n = length(y);
size_X = size(X);
COV_MLE = zeros(size_X(2),size_X(2),c);
MU_MLE = zeros(size_X(2),c);
for k = 1 : c
    ind=find(y==labels(k));
    if ~isempty(ind)
        X_k = zeros(length(ind),size_X(2));
        for i = 1 : length(ind)
            X_k(i,:) = X(ind(i),:);
        end
        if n == 1
            COV_MLE(:,:,k) = eye(size_X(2));
        else
            COV_MLE(:,:,k) = cov(X_k);
        end
        MU_MLE(k,:) = mean(X_k,1);
        
        if COV_old(:,:,k) == 0.*COV_old(:,:,k)
            COV_old(:,:,k) = eye(size_X(2));
            MU_old(k,:) = [0 0];
        end
        MU_new(k,:) = inv((new(k).*inv(COV_MLE(:,:,k))+prior(k).*inv(COV_old(:,:,k))))*...
            (new(k).*inv(COV_MLE(:,:,k))*MU_MLE(k,:)'+prior(k).*inv(COV_old(:,:,k))*MU_old(k,:)');
        COV_new(:,:,k) = inv(new(k).*inv(COV_MLE(:,:,k))+prior(k).*inv(COV_old(:,:,k)));
    end
end

param = struct('COV', COV_new, 'MU', MU_new, 'labels', labels);

end

