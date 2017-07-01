function mdf_plot(mat, basedir, number)
% function mdf_plot(mat, basedir, number)
%
% plots mat as density plot and saves it
% into basedir, 'pics/zebra_',nummer,'.jpg'
%
% input     mat         matrix with measurement to plot
%           basedir     string containing dir where to save pictures
%           number      number in filename to be saved
%

  submat= normmat_std(mat(1:4000, :));
  
  clf;
  pcolor(submat');
  shading flat
  
  filename= [basedir, '/pics/zebra_', ...
            num2str(number, '%04d'), '.jpg'];
  print ('-djpeg', filename);
  
end