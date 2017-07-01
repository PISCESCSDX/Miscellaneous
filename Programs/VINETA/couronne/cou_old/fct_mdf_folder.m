function [] = fct_mdf_folder(defch)
%function [] = fct_mdf_folder(defch)
%
% Calculates fft, zebra and kf of a subfolder-system and saves the data to
% a mat-file.
% 2 Steps:
% (1) Looks into the directories of the current directory wether there
%     are mdf-files.
% (2) Calculates in these folders the fft, zebra and kf-spectra.
%
% m-files NEEDED:   fct_mdfcalc
%                   mdf_list
%                   
% input     defch           row vector with defect channels
%           fft_probe       set the number of the probe-signal which should
%                           be used for the fft
%                           '-1' mean over all 64 probes!
% output    result matrix 'fft_kf_calc.mat'
%
% EXAMPLE: function [] = fct_mdf_folder(defch)

if nargin<1
    disp('NO DEFECT CHANNELS ASSUMED ...');
    defch = [];
end;

% test all folders wether there is an mdf-file-save error
% looks in these folders (but not '..' and '.') which ones contains *.MDF
% out:  mdfdir(1, :) .. numbers of folders in a
%       mdfdir(2, :) .. amount of mdf-clusters (1mdfcluster=8mdf-files)
a=dir;
mdfdir=[];
ctr=1;
for i=1:size(a, 1)
    a(i).name;
    if a(i).isdir==1 & a(i).name~='..'
        cd(a(i).name);
        b=dir('*.MDF');
        if size(b, 1) > 0
            [fn em es]=mdf_list;
            % test wether there is an mdf-save error
            if es==0
                mdfdir(1,ctr)=i;
                mdfdir(2,ctr)=size(fn,2);
                ctr=ctr+1;
            end;
        end;
        if a(i).name~='.'
            cd('..');
        end;
    end;
end;


% calculate all mdf-clusters
sc=clock_int;
if size(mdfdir, 2)>0
    for k=1:size(mdfdir, 2)
        cd(a(mdfdir(1,k)).name);
        disp('==========');
        disp(['Evaluation of directory: ' a(mdfdir(1,k)).name]);
        fct_mdfcalc(defch, -1, 30000, 5000, [0 25]);
        cd('..');
    end;
end;

% show calculation time
ec=clock_int; 
disp(['begin: ' sc]);
disp(['end:   ' ec]);