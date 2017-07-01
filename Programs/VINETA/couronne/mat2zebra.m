function [time phi mat] = mat2zebra(A, tt, tint, t1, matsmooth)
%function [time phi mat] = mat2zebra(A, tt, tint, t1, matsmooth)
%Shrinks a whole Couronne measurement to the size which should be shown.
%
% IN: A:     matrix [64xn sample], 64 channels (2pi)
%     tt:    vector [n x 1] time in s
%     tint:  time interval /ms
%     t1:    start point of tseries
%     matsmooth:  1: yes; 0: no
%OUT: time:  interplated time-vector
%     phi:   interpolated phi-vector
%     mat:   matrix [n x 64] n sample, 64 channels (2pi)
%
% EX: [time phi mat] = mat2zebra(A, tt, tint, t1, 1/0);

% # SIZE OF SHOW MATRIX [ pnt x pnt ]
  pnt = 500;
% TIME INTERVAL
  dt = tt(2)-tt(1);
% Azimuthal VECTOR
  phivec = linspace(0, 2, 64)';   

if nargin < 5; matsmooth = 1; end;
if nargin < 4; t1 = 1; end;
if nargin < 3; tint = 4; end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE POINTS FOR TIME INTERVAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
tint = (t1:round(tint*1e-3/dt+t1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2d-SMOOTH & DATA REDUCTION to chosen time interval
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % interval for 2d-smoothing 10 times longer than show interval
% smint = tint(1):( (tint(end) + 10*(tint(end)-tint(1))) );
% if matsmooth==1; 
%   if smint(end) > size(A,2)
%     smint = tint(1):(tint(end);
%   end
%   mat = normmat_std( A(:, smint) , 0); 
% end;

% interval for 2d-smoothing 10 times longer than show interval
if matsmooth==1
  mat = normmat_std( A(:, tint) , 0);
end
mat = mat(:, 1:length(tint));
time = tt(tint);
time = time - time(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INTERPOLATION TO GRID [pnt x pnt]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[time, phi, mat] = interp_matrix(time, phivec, mat, [pnt pnt]);

end