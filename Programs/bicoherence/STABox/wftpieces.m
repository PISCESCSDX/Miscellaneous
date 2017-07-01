function [tt,fvec,W]=wftpieces(A, dt, nff, fmax, nwin, ovl, om)
%function [tt,fvec,W]=wftpieces(A, dt, nff, fmax, nwin, ovl, om)
%Wavelet transform of big time series. autosaved on)
% A: time serie
% dt: time interval of A
% nff (def.: 400)
% fmax: maximal frequency
% nwin: split A in nwin parts overlapping with ovl
% ovl: overlap (even number)
% om: omitted numbers in output vector (THIS SAVES THE MEMORY!)
%
% EX: fmax=30e3; nwin=5M ovl=200; om=50;
%     [tt,fvec,W]=wftpieces(A, dt, 400, 30e3, 5, 200, 50)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WAVELET ANALYSE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cut the long signal into overlapping pieces, make the WFT for each one
% reduce the matrix, for comfortable size (RAM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% length of one part
lA = length(A);
ll = (lA + (nwin-1)*ovl)/nwin;
ld = ll - ovl;
ld2= ll - ovl/2;
% DEFINE INDEX CHARACT. INDEX NUMBERS
  tv = 1:om:ld2;
  iend2 = tv(end);
% reduction of output matrix (1: no reduction)
 W = [];
iW = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:nwin
  dAa = ((i-1)*ld)+1;
  dAb = i*ld+ovl;
  %%%%%%%%%%%%%%%%%%%%%%%%
  % WAVELET CORE FUNCTION
  %%%%%%%%%%%%%%%%%%%%%%%%
  [tf, fvec, C] = fspec(A(dAa:1:dAb), 1/dt, nff, 1, fmax);
  newdt = tf(om+1)-tf(1);
  %%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%
  % CUTTING
  %%%%%%%%%%%%%%%%%%%%%%%%    
  if i==1
     W = [W C(:, 1:om:ld2)];
    iW = [iW ((1:om:ld2)+dAa-1)];
    ia = 1;
    ie = iend2; % ok
  else
    if i==nwin
      nia = ie-dAa+om+1;
      W = [W C(:, nia:om:end)];
      iW = [iW ((nia:om:ll)+dAa-1)];
      ia = nia + dAa -1;
        hh = nia:om:length(C(:,1:end));
      ie = hh(end) + dAa-1;
    else
      nia = ie-dAa+om+1;
      W = [W C(:, nia:om:ld2)];
      iW = [iW ((nia:om:ld2)+dAa-1)];
      ia = nia + dAa-1;
        hh = nia:om:length(C(:,1:ld2));
      ie = hh(end) + dAa-1;
    end
  end
  [i dAa dAb ia ie]
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[a b] = size(W);
tt = (1:b)*newdt;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE
  wavfspec.W    = W;
  wavfspec.avW  = mean(W);
  wavfspec.tt   = tt;
  wavfspec.fvec = fvec;
  save wavfspec.mat wavfspec;
  disp('... data is successfully stored in file wavspec.mat')

end