function [fpath fname] = fnamesplit(f)
%==========================================================================
%function [] = fnamesplit(fname)
%--------------------------------------------------------------------------
% FNAMESPLIT splits a pathname of a file into the path and the filename.
%--------------------------------------------------------------------------
% IN: f: string of complete filename
%OUT: fpath: string of path
%     fname: string of filename
%--------------------------------------------------------------------------
% EX: [fpath fname] = fnamesplit(fname);
% C. Brandt, 09.02.2012, San Diego
%==========================================================================

if ispc == 1
  ind = strfind('\', f);
else
  ind = strfind('/', f);
end

if ~isempty(ind)
  fpath = f( 1:ind(end) );
  fname = f( ind(end)+1:end );
else
  fpath = '';
  fname = f;
end
    
end