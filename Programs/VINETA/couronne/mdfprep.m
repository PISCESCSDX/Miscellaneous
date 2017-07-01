function [mat tt] = mdfprep(fname, defch, ttcutvec)
%function [mat tt] = mdfprep(fname, defch, ttcutvec)
% Delete bad channels, cut out the useful part of the time series
% (ttcutvec). For all MDF-files of the current folder.
%
% IN: defch   vector with bad channels
%     ttcutvec
%OUT: bin-files
% EX: [A tt] = mdfprep(fname, [], ttcutvec);

if nargin<2; defch = []; end;
if nargin<1; error('Input of filename is missing!'); end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ MDF-file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[A tt] = readmdf(fname);
if nargin<3; ttcutvec=1:length(tt); end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CUT AWAY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = A(ttcutvec, :);
tt = tt(ttcutvec);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TRANSPOSE matrix to [probes x time]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = A'; tt = tt';
n = size(A,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DELETE DEFECT CHANNELS (defch)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Avoid bad channels on the margin of the matrix - that would
% result in NaN-rows at margins during the interpolation procedure!
hilfs = zeros(64, 1);  hilfs(defch) = 1;  matrot = 0;
while hilfs(1)==1 || hilfs(64)==1
  hilfs = circshift(hilfs, 1);
  matrot = matrot + 1;
  if matrot > 64
    error('Too much defect channels for matrix interpolation!');
  end;
end;
%
if ~isempty(defch)
  A(defch, :) = NaN;
  A = circshift(A, matrot);
  [A keepind] = remove_nan(A);
  % interpolate deleted channels - matrix gets original size [64xSamples]
  A = interp2((1:n), find(keepind==1), A, (1:n), (1:64)', 'linear');
  % rotate matrix back
  A = circshift(A, -matrot);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REMOVE LOW FREQUENCY NOISE (LOW NOISE FOR DRIFT WAVES <700Hz)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mat = rem_lowfnoise(A, tt, 700);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NORMALIZE MATRIX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%mat = normmat_std(mat, 0);

end