function fct_plotstyle_lines(filename, DA, DO, DD)
%==========================================================================
%function fct_plotstyle_lines(filename, DA, DO, DD)
% June 6 (2012), Christian Brandt, (UCSD, CER)
% inspired by: fix_dottedline
%--------------------------------------------------------------------------
% Adjust dashed, dotted and dash-dotted line distances between 
% black and white.
%--------------------------------------------------------------------------
% EXAMPLE:
% fn = 'diagram.eps';
% DO.Lb = 4; % length black
% DO.Lw = 1; % length white
% DA.Lb = 6; % length black
% DA.Lw = 2; % length white
% fct_plotstyle_lines(fn, DA, DO)
%==========================================================================

% *** Not yet included:
if nargin<4
  DD.Lb = 3; % length black
  DD.Lw = 2; % length white
end

if nargin<3
  DO.Lb = 1; % length black
  DO.Lw = 1; % length white
end

if nargin<2
  DA.Lb = 3; % length black
  DA.Lw = 2; % length white
end

fid = fopen(filename,'r');
tempfile = tempname;
outfid = fopen(tempfile,'w');

repeat = 1;
while repeat==1
    thisLine = fgetl(fid);
    iStart = strfind(thisLine,'/DO { [.5');
    if iStart
      %OLD thisLine(iStart+7:iStart+8) = '01';
      thisLine=['/DO { [' num2str(DO.Lb) ' dpi2point mul ' ...
        num2str(DO.Lw) ' dpi2point mul] 0 setdash } bdef'];
    end
    
    iStart = strfind(thisLine,'/DA');
    if iStart
      thisLine=['/DA { [' num2str(DA.Lb) ' dpi2point mul ' ...
        num2str(DA.Lw) ' dpi2point mul] 0 setdash } bdef'];
    end
    
    iStart = strfind(thisLine,'/DD { [.5');
    if iStart
        thisLine(iStart+7:iStart+9) = '1.5';
        thisLine(iStart+10:end+1) = [' ' thisLine(iStart+10:end)];
        %thisLine=['/DD { [1.5 dpi2point mul 4 dpi2point mul 6 '...
        %  'dpi2point mul 4 dpi2point mul] 0 setdash } bdef'];
    end

    if ~ischar(thisLine)
        repeat = 0; 
    else
        fprintf(outfid,'%s\n',thisLine);
    end
end
    
fclose(fid);
fclose(outfid);
copyfile(tempfile, filename);
delete(tempfile);

end