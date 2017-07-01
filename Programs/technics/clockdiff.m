function clockdiff = clockdiff(t1, t2)
%==========================================================================
%function clockdiff = clockdiff(t1, t2)
%--------------------------------------------------------------------------
% Jan-17-2007, C.Brandt, IPP Greifswald
% May-22-2013, C.Brandt, UC San Diego
% Compute the time difference from two CLOCK_INT times.
%--------------------------------------------------------------------------
%INPUT
% t1, t2: clockstrings 1 and 2 from clock_int
%OUTPUT
% clockdiff: string of time difference: time_2 - time_1
%--------------------------------------------------------------------------
% EXPAMPLE: a = clockdiff(t1, t2);
%--------------------------------------------------------------------------
% DEBUGGING: "Time Probe":
% t1 = clock_int;
% <Code>
% t2 = clock_int;
% disp(clockdiff(t1,t2))
%==========================================================================

csec1 = str2num(t1(18:19)) + str2num([t1(21:23) t1(25:27) t1(29:31)])/1e9;
csec2 = str2num(t2(18:19)) + str2num([t2(21:23) t2(25:27) t2(29:31)])/1e9;
cmin1 = str2num(t1(15:16));
cmin2 = str2num(t2(15:16));
chour1= str2num(t1(12:13));
chour2= str2num(t2(12:13));
cday1 = str2num(t1(9:10));
cday2 = str2num(t2(9:10));
cmth1 = str2num(t1(6:7));
cmth2 = str2num(t2(6:7));
cyear1= str2num(t1(1:4));
cyear2= str2num(t2(1:4));

cdate1 = datenum(cyear1, cmth1, cday1);
cdate2 = datenum(cyear2, cmth2, cday2);

diff_sec = csec2 - csec1;
diff_min = cmin2 - cmin1;
diff_hour = chour2 - chour1;
diff_day = cdate2 - cdate1;

diff_time = diff_sec + diff_min*60 + diff_hour*3600 + diff_day*24*3600;
if diff_time<0 
  prefix = '-';
else
  prefix = '+';
end
diff_time = abs(diff_time);
diff_day =  floor(diff_time/(24*3600));
diff_hour = floor((diff_time/(24*3600)-diff_day)*24);
diff_min = floor(((diff_time/(24*3600)-diff_day)*24-diff_hour)*60);
diff_sec = (((diff_time/(24*3600)-diff_day)*24-diff_hour)*60-diff_min)*60;

% Create strings with appropriate amount of spaces
str_d = [pre_string(diff_day, 1000, ' ') num2str(diff_day)  'd'];
str_h = [pre_string(diff_hour,  24, ' ') num2str(diff_hour) 'h'];
str_min=[pre_string(diff_min,   59, ' ') num2str(diff_min)  'min'];
str_sec=[pre_string(diff_sec,   59, ' ') num2str(floor(diff_sec))  's'];
str_mus=[pre_string(diff_sec,999999,' ') ...
  num2str( 1e6*(diff_sec-floor(diff_sec)) ) 'mus'];

% Create output variable
clockdiff = {[prefix str_d ' ' str_h ' ' str_min ' ' str_sec ' ' ...
  str_mus]};
clockdiff = cell2mat(clockdiff);
    
end