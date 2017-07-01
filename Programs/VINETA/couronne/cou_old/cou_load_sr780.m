function [freq, ampl]= cou_load_sr780(file_number)
%
%
%function [freq, ampl]= cou_load_sr780(amount_of_files)
%
% COU_LOAD_SR780 loads dataset from measurements of SR780. 
% Name has to be of the form: "SR780_000000.dat".
% It is assumed that the data is in the current directory.
%
% input     file_number number of the file to load (default=0)
% output    freq        frequency axis
%           ampl        measured amplitudes
%
% EXAMPLE:  [freq, ampl]= cou_load_sr780(4)

    if nargin < 1
        file_number= 0;
    end
    
    filename = my_filename(file_number, 6, 'SR780_', '.dat');
    a = load_raw_data(filename);
    freq=a(:,1);
    ampl=a(:,2);
    
    % repair error of freq axis in the last value
    fl=length(freq);
    freq(fl)=freq(fl-1)+freq(2)-freq(1);
end