function cnmeva(tint, t1, ch, diph, fftlim, kflim, wl)
%function cnmeva(tint, t1, ch, diph, fftlim, kflim, wl)
% Evaluates all BIN-files of the current directory.
% needs: readbin
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evaluation AND PLOT of the couronne
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (1) Find defect channels in couronne:
%     [A tt] = readmdf('cou0001.MDF');
%     plot(std(A)) --> look where the std is closely to zero
% (2) Find the interval where to plot the couronne data
%     plot(A(:,1))
% (3) Find wether the couronne has to be flipped /// -> flipon, \\\ -> flipoff
% (4) look which channel is typical for the spectrum
%
% *** ODER einfach alles mit der Funktion: checkcouronne('cou0001.MDF')
% int = 1:110e3;
% defch = [40];
% flip = 'flipon';
% mdf2bin(defch, 'flipon', [1:3], int);
%
% phase_corr = 0; ch=24; wL = 20;
% cnmeva(6, 1, ch, phase_corr, [0 60e3], [0 30e3], wL);
%
% clim_fac = 2;
% plotcoulist(1, 0, [1:3], 2, 0, 'abcd', clim_fac)
% print_adv([0 0 0 1], '-r300', 'control-eex-sydw-1_x150.eps', 50); close
%
% plotcoulist(2, 0, [1:3], 2, 0, 'efgh', clim_fac)
% print_adv([0 0 0 1], '-r300', 'control-eex-sydw-2_x150.eps', 50); close
%
% plotcoulist(3, 1, [1:3], 2, 0, 'ijkl', clim_fac)
% print_adv([0 0 0 1], '-r300', 'control-eex-sydw-3_x150.eps', 50); close
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% IN: tint: time interval (ms)  which should be shown in the timeplot
%           and in the zebraplot
%     t1: start point of tseries
%     ch: number of channel shown in the time trace
%     diph(opt): dirty phase: 1 - correct, 0 - don't
%     fftlim: [fbeg fend]
%     kflim: [kfbeg kfend]
%     wl: window length [%] for fft-calc, kf-calc
%OUT:
% EX: cnmeva(4, 1, 1, 0, [0 30e3], [0 30e3], 2);
%     cnmeva(6, 1, 1, 0, [0 60e3], [0 30e3], 2);

% # INPUT: Window length: fft- und kf-Spektren: 10
if nargin<7; wl = 2; end;
if nargin<6; kflim=[0 25e3]; end;
if nargin<5; fftlim=[0 25e3]; end;
if nargin<4; diph=0; end;
if nargin<3; ch=1; end;
if nargin<2; t1=1; end;
if nargin<1; tint=4; end;

a = findfiles('cnm*.BIN');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOR LOOP ... evaluate all BIN-files!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(a)    

  % FILE NAME BUSINESS
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  disp_num(i, length(a));
  var_help = cell2mat(a(i));
  i_cou = str2num( var_help(end-7:end-4) );

  % READ DATA
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [A tt] = readbin( cell2mat(a(i)) );

  % REMOVE DIRTY PHASE (not recommended, since this is really dirty)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if diph==1
    [A tt diphfit] = dirtyphase(A, tt);
  end;

  A = A';
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % TIME TRACE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  disp('... time series');
  dt = tt(2)-tt(1);
  tintind = (t1:round(2*tint*0.001/dt+t1));
  ttrace = tt(tintind);  ttrace = ttrace-ttrace(1);
  tsig{i} = A(ch, tintind);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % FFT-SPECTRUM
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  disp('... fft spectrum');
  [freq am phas] = fft64mean(A, tt, wl, 0.5);
  i_f = find(freq>800 & freq<fftlim(2));
  freq = freq(i_f);
  ampl{i} = am(i_f);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % ZEBRA-PLOT
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  disp('... zebra plot');
  [zt phi zA{i}] = mat2zebra(A, tt, tint, t1, 1);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % KF-SPECTRUM
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  disp('... kf-spectrum');
  [kff, kfmvec, kfmat{i}, kfaxis{i}] = mat2kf(A, tt, kflim, [0 8], wl);

end;

save('1____tt.mat', 'ttrace', 'tsig');
save('2___fft.mat', 'freq', 'ampl');
save('3_zebra.mat', 'zt', 'phi', 'zA');
save('4____kf.mat', 'kff', 'kfmvec', 'kfmat', 'kfaxis');

end