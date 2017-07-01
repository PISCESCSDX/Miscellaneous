function [upperenv lowerenv] = envelope(sig, method)
%==========================================================================
%function [upperenv lowerenv] = envelope(sig, method)
%--------------------------------------------------------------------------
% Aug-30-2013, Christian Brandt, San Diego (downloaded from MATLAB Central)
% ENVELOPE finds upper and lower envelopes of a given signal
% The idea is from Envelope1.1 by Lei Wang, but here it works well when the
% signal contains successive equal samples and also includes first and last
% samples of the signal in the envelopes.
%--------------------------------------------------------------------------
%INPUT
% sig: vector of input signal
% method: method of interpolation (defined as in interp1)
%OUTPUT
% upperenv: upper envelope of the input signal
% lowerenv: lower envelope of the input signal
%--------------------------------------------------------------------------
%EXAMPLE
% t = (1:10000)*1e-5;
% s = sin(2*pi*2000*t).*sin(2*pi*2060*t);
% [upperenv lowerenv] = envelope(s);
% hold on; plot(s); plot(upperenv,'m'); plot(lowerenv,'g'); 
%==========================================================================

if nargin == 1 
    method = 'linear';
end
upperind = find(diff(sign(diff(sig))) < 0) + 1;
lowerind = find(diff(sign(diff(sig))) > 0) + 1;
f = 1;
l = length(sig);
try
    upperind = [f upperind l];
    lowerind = [f lowerind l];
catch 
    upperind = [f; upperind; l];
    lowerind = [f; lowerind; l];
end
xi = f : l;
upperenv = interp1(upperind, sig(upperind), xi, method, 'extrap');
lowerenv = interp1(lowerind, sig(lowerind), xi, method, 'extrap');

end