function [phi_unwrapped, alpha] = phasedetector(sig)
%==========================================================================
%function [phi] = phasedetector(sig)
% June 6 (2012), Christian Brandt, San Diego (UCSD, CER)
%--------------------------------------------------------------------------
% PHASEDETECTOR calculates the phase angle of any fluctuating signal using
% the Hilbert transform.
%--------------------------------------------------------------------------
% IN: sig: time series, simply only the signal
%OUT: alpha: phase in radiant
%     phi_unwrapped: phase of the signal in units of pi
%--------------------------------------------------------------------------
% EXAMPLE:
% alpha = (((1:1000)')/1000)*10*2*pi;
% sig = sin( (((1:1000)')/1000)*10*2*pi );
% phi = phasedetector(sig);
% subplot(3,1,1); plot(alpha/pi);
% subplot(3,1,2); plot(sig);
% subplot(3,1,3); plot(phi);
%==========================================================================

hi = hilbert(sig);
alpha  = angle(hi);
phi_unwrapped = unwrap(alpha)/pi+0.5;

end