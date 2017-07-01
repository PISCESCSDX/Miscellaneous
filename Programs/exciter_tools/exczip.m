function [cl] = exczip();
%function [cl] = exczip();
% Load data of exciter setting and saves it in one file.
% m-files NEEDED:   load_raw_data
% IN:
%OUT: file with: 
% 1: No. #
% 2: Wait after Plasma On [ms]
% 3: Amplitude [V]
% 4: 0
% 5: Mode No. (m<0 co-rotating)
% 6: fstart [Hz]
% 7: fend [Hz]
% 8: No. Pulses #
% 9: pulse Length [ms]
%10: pulse off [ms] (between pulses)
% EX: exczip


a = dir('_excsettings*');

fnum = size(a, 1);

% init compressed list
  cl = [];

for i=1:fnum
  data = load_raw_data(a(i).name, '%--', ' ');
  delete(a(i).name);
  cl = [cl; i data];
end;

save exc.dat cl -ascii;
save exc.mat cl;
    
end