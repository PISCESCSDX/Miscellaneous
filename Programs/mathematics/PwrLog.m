function [logS] = PwrLog(S)
%function [logS] = PwrLog(S)
% Calculate a signal into dB.
% IN: S(vec) signal vector
%OUT: logS: 10*log10(S)

logS = 10*log10(S);

end