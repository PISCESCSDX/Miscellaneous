function fct_plotstyle_lines_individual(filename, sty, linsty)
%==========================================================================
%function fct_plotstyle_lines_individual(filename, sty, linsty)
% Aug-23-2013, Christian Brandt, (UCSD, CER)
% inspired by: fix_dottedline
%--------------------------------------------------------------------------
% Add new line styles to plot. And change line styles.
% INPUT:
%  filename: string with filename
%  sty: cell structure with line styles
%  linsty: vector specifying which line which style
%--------------------------------------------------------------------------
% EXAMPLE: (two lines)
% fn = 'diagram.eps';
% sty{1} = [1 1 3 1]; % lengths: black, white, black, white
% sty{2} = [2 2 6 2]; % lengths: black, white, black, white
% linsty(1) = 1; % line number 1, style 1
% linsty(2) = 2; % line number 2, style 2
% fct_plotstyle_lines_individual(fn, sty, linsty);
%==========================================================================

fid = fopen(filename,'r');
tempfile = tempname;
outfid = fopen(tempfile,'w');



repeat = 1;
% Set line counter
ili = 0;

ascii = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
ctr=0;
thisLine = [];
nextLine = fgetl(fid);

while repeat==1
  ctr=ctr+1;
  lastLine = thisLine;
  thisLine = nextLine;
  nextLine = fgetl(fid);

  % First: Add new line definitions to header
  idef = strfind(thisLine,'% line types:');
  if idef
    % Example of dashed dotted line definition:
    % /DD { [1.5 dpi2point mul 4 dpi2point mul 6 dpi2point mul 4 dpi2point 
    %        mul] 0 setdash } bdef
    for jsty=1:length(sty)
      
      linestr{jsty} = ['DA' ascii(jsty)];
      
      newLine=['/' linestr{jsty} ' { [' ...
        num2str(sty{jsty}(1)) ' dpi2point mul ' ...
        num2str(sty{jsty}(2)) ' dpi2point mul ' ...
        num2str(sty{jsty}(3)) ' dpi2point mul ' ...
        num2str(sty{jsty}(4)) ' dpi2point mul ' ...
        '] 0 setdash } bdef'];
    fprintf(outfid,'%s\n',newLine);
    end
  end
  
  
  iStartDD = strcmp(thisLine,'DD');
  iStartDA = strcmp(thisLine,'DO');
  if iStartDD || iStartDA
    if ~strcmp(nextLine,'0 sg') && ~strcmp(lastLine,'0 sg')
      ili= ili+1;
      thisLine=[ linestr{linsty(ili)} ];
    end
  end


  if ~ischar(nextLine)
    fprintf(outfid,'%s\n',thisLine);
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