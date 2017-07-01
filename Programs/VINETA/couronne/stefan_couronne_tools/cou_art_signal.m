function [sig, time]= cou_art_signal(amp, smplen, srate, f, m)
%
%function [sig, time]= cou_art_signal(amp, smplen, srate, f, m)
%
% Produce artificial signal as if it was from Couronne.

    if nargin < 5, m=2;           end
    if nargin < 4, f= 5e3;        end
    if nargin < 3, srate= 1.25e6; end
    if nargin < 2, smplen= 64e3;  end
    if nargin < 1, amp= 1;        end

    time= [0: (smplen-1) ]' ./ srate;
    time_mat = time * ones(1, 64);
    theta_mat= ones(smplen, 1) * [0:63];
    
    sig= amp .* sin(theta_mat .* (m * 2 * pi / 64) - ...
                    time_mat  .* (f * 2 * pi) );
         
    sig= (sig + 1) .^ 1;


end