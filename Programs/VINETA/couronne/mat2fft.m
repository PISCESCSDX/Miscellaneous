function [fvec ampl phas] = mat2fft(A, tt, flim, wl, defch);
%function [freq ampl phas] = mat2fft(A, tt, flim, wl, defch);
% m-files needed:	fft64mean
% input:    A       mxn matrix
%           tt      time row
%           flim    limits of freq-axis: [fmin fmax] /Hz
%           defch   vector with defect channels
% output:   freq    frequency axis
%           ampl    amplitudes
%           phas
% EXAMPLE: [freq ampl phas] = mat2fft(A, tt, flim, wl, defch);

if nargin<5; defch = []; end;
if nargin<4; wl = 50; end;
if nargin<3; flim=[0 25e3]; end;


   [fvec ampl phas] = fft64mean(A, tt, wl);

   f_ind = find(fvec>=flim(1) & fvec<=flim(2));
   fvec = fvec(f_ind);
   ampl = ampl(f_ind);
   phas = phas(f_ind);

end