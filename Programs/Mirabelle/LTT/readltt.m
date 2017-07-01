function [tvec, A] = readltt(filebase)
%==========================================================================
%function [tvec, A] = readltt(file)
%--------------------------------------------------------------------------
% READLTT reads the matlab data file from transient recorder LTT.
%--------------------------------------------------------------------------
% IN: file: string of the filename base, e.g. 'ltt01' for ltt01.mat
%OUT: tvec: time vector
%     A:    data matrix, A(ch,:);
%==========================================================================

% Load the MatLab data file
  matfile = load(filebase);
% Load rawdata into variables
  scaling  = matfile.(strcat(filebase, '_scaling_'));
  timedata = matfile.(strcat(filebase, '_timedata_'));
  rawdata  = matfile.(strcat(filebase, '_rawdata_'));
  rawdata = rawdata';
% Number of channels
  chnum = size(rawdata,2);

% Correct the scales
for i=1:chnum
  A(:,i) = double(rawdata(:,i))*scaling(2,i);
end
% introducting the time step
  tsteps = size(rawdata,1);
  dt = timedata(2)/chnum;
%la ligne au dessus est bizarre, mais c'est comme ca que le .mat est fait
  tvec = (0:dt:dt*(tsteps-1))'*1e-6;

end