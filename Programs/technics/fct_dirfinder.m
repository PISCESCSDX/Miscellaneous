function [mdir cdir] = fct_dirfinder(a);
% 20061106 C. Brandt
%function [mdir cdir] = fct_dirfinder(a);
%Find out the current directory and subdirectory.
% Reads the name of the current directory and saves it to cdir.
% Reads the name of the subdirectory of cdir and saves it to mdir.
%
% m-files NEEDED:   
% input     a    string with current directory
% output    mdir    main folder
%           cdir    folder where file is/will be saved
% EXAMPLE: [mdir cdir] = fct_dirfinder(a);

if nargin < 1
    a = pwd;
end;

a1 = size(a);
x = strfind(a, '/');
x1 = size(x);
cdir = [a(x(x1(2))+1:a1(2))];
mdir = [a(1:x(end))];

