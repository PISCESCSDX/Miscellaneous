function [fcut scut] = fspcut(f,s,fend)
%FSPCUT (fspectrum cutted)
% Cuts a fspectrum till a frequency fend.
% IN: f: frequency vector
%     s: signal vector
%     fend: new end frequency
%OUT: fcut: to fend cutted frequency vector
%     scut: appropriate cutted signal vector

% find indices till fend
  f_i = find(f<fend);

  fcut = f(f_i);
  scut = s(f_i);

end