function [] = mdf2bin(defch, fliponoff, cou_list, ttcutvec)
%function [] = mdf2bin(defch, fliponoff, cou_list, ttcutvec)
% 1: Open cou*.MDF-files of current folder.
% 2: Delete bad channels. 
% 3: Normalize matrix.
% 4: Interpolate matrix.
% Before mdf2bin use "mdfzip" to get cou*.MDF files.
% If slope in the zebra-plots is negative \\\ use 'flipoff',
%                             if positive /// use 'flipon'.
% NEEDS: mdfnorm, findfolders, clock_int, clockdiff, savebin,
% my_filename, disp_num
%
% IN: defch: vector with bad channels
%     fliponoff: 'flipon' flip matrix, 'flipoff' don't flip
%     cou_list: 1d-vec of file numbers, which should be evaluated
%     ttcutvec: cut away parts where signals are zero (for example)
%OUT: BIN-files
% EX1: mdf2bin([], 'flipon', [2:5 8 10 12:22]);
% EX2: mdf2bin([], 'flipon', [], (1:115e3));

if nargin<3; cou_list=[]; end;
if nargin<2; fliponoff = 'flipoff'; end;
if nargin<1; defch = []; end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET the START CLOCK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sc=clock_int;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET COU-Files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flist = findfiles('cou*MDF');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GO THROUGH cou_list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(cou_list); cou_list = 1:length(flist); end
for i=1:length(cou_list)
  disp(['cou 2 BIN of ' flist{ cou_list(i) }]);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % NORMALIZATION
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [A tt] = mdfprep( flist{cou_list(i)} , defch, ttcutvec);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % FLIP/NOT FLIP MATRIX (ONLY POSITIVE PART OF MODES in kf-plots)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  switch fliponoff
    case 'flipon'
      A=fliplr(A);
    case 'flipoff'
      A=A;
  end;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % GET the filepath
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [fpath fname] = fnamesplit(flist{cou_list(i)});
  num = str2num( fname(4:7) );
  savename = [fpath my_filename(num, 4,'cnm','.BIN')];
  % save complete matrix with 16bit resolution to BIN-file
  savebin(savename, A', tt);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHOW FREQUENCY RESOLUTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dt = tt(2)-tt(1);
lA = length(A);
T  = lA * dt;
fres = 1/T;
disp(['frequency resolution if window length (wL) = 100 %: ' num2str(fres)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHOW calculation time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  ec = clock_int; 
  disp(['DURATION OF BIN-FILE-CREATION']);
  disp(['begin: ' sc]);
  disp(['diff:      ' clockdiff(sc, ec)]);
  disp('... continue with <<cnmeva>>');

end