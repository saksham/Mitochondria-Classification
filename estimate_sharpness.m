function [sharpness]=estimate_sharpness(G)
% ESTIMATE_SHARPNESS: Estimates the sharpness using the gradient magnitude.
% Sum of all gradient norms / number of pixels give us the sharpness
% metric.

[Gx, Gy]=gradient(G);

S=sqrt(Gx.*Gx+Gy.*Gy);
sharpness=sum(sum(S))./(numel(Gx));

end

