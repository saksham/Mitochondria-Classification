function [sharpness]=estimateSharpness(I)
% ESTIMATESHARPNESS: Estimates the sharpness using the gradient magnitude.
% sharpness = estimateSharpness(I)
% Sum of all gradient norms / number of pixels give us the sharpness
% metric.
%   I: image whose sharpness is to be computed
%
% See also: NORMALIZEIMAGE
%

[Gx, Gy]=gradient(double(I));

S=sqrt(Gx.*Gx+Gy.*Gy);
sharpness=sum(sum(S))./(numel(Gx));

end

