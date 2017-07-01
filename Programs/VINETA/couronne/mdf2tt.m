function [] = mdf2tt(num, tint, t1, ch);
%function [] = mdf2tt(num, tint, ch);
% m-files needed:   readmdf, plottt
% input:    num     xxxx number of "couxxxx.MDF" file
%           tint    time intervall /ms
%           t1      start point of tseries
%           ch      channel to show
% output:   plot of the time trace
%
% EXAMPLE:  mdf2tt(num, tint, ch);

if nargin<4
    ch = 1;
end;

if nargin<3
    t1 = 1;
end;

if nargin<2
    tint = 4;
end;

if nargin<1
    error('Number of measurement is missing!');
end;



    fname = my_filename(num, 4, 'cou', '.MDF');
    [A tt] = readmdf(fname); A=A';
    
    dt = tt(2)-tt(1);
    tint = (t1:round(tint*1e-3/dt+t1));    
    
    plottt(tt(tint), A(ch, tint))
    
end