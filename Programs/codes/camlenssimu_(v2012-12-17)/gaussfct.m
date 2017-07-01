function [y, Dy] = gaussfct(x, mu, sigma)
%==========================================================================
%function [y, Dy] = gaussfct(x, mu, sigma)
%--------------------------------------------------------------------------
% Gaussian Function normalized to the area below.
%--------------------------------------------------------------------------
% IN: x: vector of x-values
%     mu: x-position of the maximum
%     sigma: FWHM
%OUT:  y: y-vector of gaussian function
%     Dy: y-vector of first derivative of y
%--------------------------------------------------------------------------
% EX: x=-4:0.1:4; mu=0; sigma=2; [y] = gaussfct(x, mu, sigma);
%==========================================================================

if nargin < 3; error('Not enough input.'); end

y = 1/(sigma*sqrt(2*pi)) * exp(-((x-mu).^2/(2*sigma^2)));

Dy= 1/(sigma*sqrt(2*pi)) .* (mu-x)./(sigma^2) ...
    .* exp(-((x-mu).^2/(2*sigma^2)));

end