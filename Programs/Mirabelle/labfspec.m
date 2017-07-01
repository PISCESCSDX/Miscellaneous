function [tvec, fvec, spec] = labfspec(dev, ch, num)
%==========================================================================
%function [tt, fre, spec] = labfft(dev, ch, num)
%--------------------------------------------------------------------------
% LABFSPEC calculates the frequency spectogram of a 
%--------------------------------------------------------------------------
% IN: dev: string of the device ('ltt', 'osc')
%     ch:  number of the channel used for the fft
%     num: number of the ltt-file in the current folder
%OUT: tt:  time vector
%     fre: frequency vector
%     spec:frequency spectogram
% EX: labfspec('ltt', 2, 1)
%==========================================================================

if nargin<3; num=1; end

fonts = 12;

% SWITCH between the devices: LeCroy and LTT
switch dev
  case 'osc'
    a = dir('*.CSV');
    [tt A] = readosc(a(1).name);
    sig = A(:,ch);
  case 'ltt'
    a = dir('ltt*.mat');
    if num>length(a)
      error(['The number of ltt file does not exist! Maximum is ' num2str(length(a)) '.']);
    end
    disp(['read ' a(num).name(1:end-4) ' ...'])
    [tt A] = readltt(a(num).name(1:end-4));
    sig = A(:,ch);
end

ls = length(sig); fwinpts = round(ls/20);
[tvec, fvec, spec] = fspectrogram(tt, sig, fwinpts);
i_f  = find(fvec>=0.8e3 & fvec<=25e3);
fvec = fvec(i_f);
spec = spec(i_f, :);

% Plot
%==========================================================================
figeps(14,9,1,0.4,59.2);
axes('position', [0.10 0.18 0.85 0.80]);
A = 20*log10(spec);
subplotfspec(tvec, fvec, A);
shading flat
caxis([min(min(A))+40 max(max(A))-10]);
[hxl hyl] = mkplotnice('time (ms)', 'f (kHz)', fonts, -25);

end