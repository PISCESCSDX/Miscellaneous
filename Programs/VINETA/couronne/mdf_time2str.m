function [date_str]= mdf_time2str(stamp)

   y= bitand(stamp, bin2dec('11111110000000000000000000000000'));
   m= bitand(stamp, bin2dec('00000001111000000000000000000000'));
   d= bitand(stamp, bin2dec('00000000000111110000000000000000'));
   H= bitand(stamp, bin2dec('00000000000000001111100000000000'));
   M= bitand(stamp, bin2dec('00000000000000000000011111100000'));
   S= bitand(stamp, bin2dec('00000000000000000000000000011111'));
   
   y= bitshift(y, -25) + 1980;
   m= bitshift(m, -21);
   d= bitshift(d, -16);
   H= bitshift(H, -11);
   M= bitshift(M, -5 );
   S= S .* 2;
   
   
   
   month= ['jan'; 'feb'; 'mar'; 'apr'; 'mai'; 'jun'; 'jul'; 'aug'; ...
           'sep'; 'oct'; 'nov'; 'dec'];
   
   date_str= ...
     [num2str(d, '%02d'), '-', ...
      month(m, :), '-', ...
      num2str(y, '%04d'), ' ', ...
      num2str(H, '%02d'), ':', ...
      num2str(M, '%02d'), ':', ...
      num2str(S, '%02d')];
      
   
end