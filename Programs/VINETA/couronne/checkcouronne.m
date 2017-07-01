function checkcouronne(fn, ch, t1, tint, probes)
%==========================================================================
% Evaluation AND PLOT of the couronne
%--------------------------------------------------------------------------
% GENERAL MANUAL for probe evaluation
% (1) Find defect channels in couronne:
%     [A tt] = readmdf('cou0001.MDF');
%     plot(std(A)) --> look where the std is closely to zero
% (2) Find the interval where to plot the couronne data
%     plot(A(:,1))
% (3) Find wether the couronne has to be flipped /// -> flipon, \\\ -> flipoff
% (4) look which channel is typical for the spectrum
% ODER einfach alles mit der Funktion: checkcouronne('cou0001.MDF')
% (4) int = 1:2^16; defch = [60:64];
%     phase_corr = 1; ch=24; wL = 40;
%     mdf2bin(defch, 'flipon', [1:3], int);
%     cnmeva(6, 1, ch, phase_corr, [0 60e3], [0 30e3], wL);
%--------------------------------------------------------------------------
% IN: fn: MDF-name, e.g. 'cou0001.mdf'
%     ch: channel of time row (default = 1)
%     t1: start point of time (default 1)
%     tint: time intervall for zebra plot (default 4ms)
%     probes: 'all' (def), 'even', 'odd'
%--------------------------------------------------------------------------
% EX: checkcouronne('cou0001.mdf', 30, 20e3, 4)
%==========================================================================

if nargin<5; probes = 'all'; end
if nargin<4; tint = 4; end
if nargin<3; t1 = 1; end
if nargin<2; ch = 1; end

[A tt] = readmdf(fn);
dt = tt(2)-tt(1);
tint = (tint/1e3)/dt;

nm = size(A,2);
Astd = std(A);

figeps(25,6,1);

axes('position', [0.07 0.22 0.24 0.7]);
plot(Astd, 'k');
set(gca, 'xlim', [1 64])
mkplotnice('probe #','std(A)', 12, -25);

axes('position', [0.42 0.22 0.24 0.7]);
plot(A(:,ch), 'k');
set(gca, 'xlim', [1 length(A(:,ch))])
mkplotnice('pts #','sig [V]', 12, -25);

axes('position', [0.73 0.22 0.24 0.7]);
switch probes
  case 'odd'
    mind = 1:2:nm;
  case 'even'
    mind = 2:2:nm;
  case 'all'
    mind = 1:nm;
end

A = A(t1:t1+tint,mind);
nt = size(A,1);
ot = ones(nt,1);
Astd = std(A);
Aavg = mean(A);
facstd = ot*Astd;
sumavg = ot*Aavg;
B = A - sumavg;
B = B./facstd;

pcolor(B'); shading flat; colormap pastell(64)
mkplotnice('pts #','probe #', 12, -25);

end