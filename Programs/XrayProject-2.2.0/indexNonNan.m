function [consecutiveIdxSequences, gapAfter, startend] = indexNonNan(col,smoothOver)

% function [consecutiveIdxSequences, gapAfter, startend] = indexNonNan(col,smoothOver)
% Inputs:   col = a single column of data 
% Outputs:  consecutiveIdxSequence =  cell array where each cell contains 
%               the index numbers of a consecutive sequence from the input.
%               NaN gaps of less than 20 will be interpolated across by 
%               default. Change the number 20 below if you desire a 
%               different gap cutoff.
%           gapAfter = number of NaN rows after each sequence
%           startend = nx2 matrix of the start and end row of each sequence
% David Baier
% last updated: 5/25/2010 initialization added.

if exist('smoothOver') == 0
    smoothOver = 1;
end

idx = find(~isnan(col));
consecutiveIdxSequences = []; gapAfter = []; startend = [];

seq = 1;
seqBegin = 1;

for i = 1:size(idx,1)-1
    check = idx(i+1,1)-idx(i,1);
    if check > smoothOver
        consecutiveIdxSequences{1,seq} = (idx(seqBegin):idx(i))';
        startend(seq,1:2) = [idx(seqBegin) idx(i)];
        gapAfter(seq) = check;
        seq = seq+1;
        seqBegin = i+1;
    end

    if  i == size(idx,1)-1
        consecutiveIdxSequences{1,seq} = (idx(seqBegin):idx(i+1))';
        gapAfter(seq) = 0;
        startend(seq,1:2) = [idx(seqBegin) idx(i+1)];
    end
end