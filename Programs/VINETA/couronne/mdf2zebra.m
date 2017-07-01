function [] = mdf2zebra(num, msec, t1, defch);
%function [] = mdf2zebra(num, msec, t1, defch);
% Creates a spatiotemporal plot ("zebra plot") from a MDF-file.
%
% m-files   mat2zebra
% input     num     xxxx number of "couxxxx.MDF" file
%           msec    time interval t-axis /ms
%           t1      number from where the time should begin
%           defch
% output    single zebraplot
%
% EXAMPLE:  mdf2zebra(151, 4)   shows 4ms of "cou0151.MDF"

if nargin<4
    defch = [];
end;

if nargin<3
    t1 = 1;
end;

if nargin<2
    msec = 4;
end;

if nargin<1
    error('Number of measurement file is missing!');
end;


    fname = my_filename(num, 4, 'cou', '.MDF');
    [A tt] = readmdf(fname); A=A';

    [time phi mat] = mat2zebra(A, tt, msec, t1, defch);

    plotzebra(time, phi, mat);
    
end