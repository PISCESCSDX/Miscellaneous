function [data, time, params] = readmdf(file)
%==========================================================================
%function [data, time, params] = readmdf(file)
%--------------------------------------------------------------------------
% Script to read mdf files recorded by the  transient recorder T112 for 
% the azimuthal probe array ("Couronne"). The code is taken from a 
% "lecmdf.m"-file from JET-Systemtechnik, and was modified in Feb. 2002. 
% C. Schröder, C. Brandt (2010)
%--------------------------------------------------------------------------
% IN: file: string of the filename (e.g. "BA000001.MDF")
%OUT: data: array [rows (length(time)), colums (length(probes))]
%     time: time trace in [s]
%--------------------------------------------------------------------------
% EX: [A, tt] = readmdf('cou0001.mdf');
%==========================================================================

if nargin<1; error('You must specify a file.'); end	
if isempty(dir(file)); error('file not found'); end

fid=fopen(file);

%MDF-Header
file_type=(setstr(fread(fid,11,'char')))';
channel_saved=fread(fid,1,'char');
sprintf('number of saved channels: %i',channel_saved);

%"SDF-Files"
for ichannel=1:channel_saved
	%just reading what is in the file
%OLD    identifier_version=(setstr(fread(fid,16,'char')))';    
        identifier_version=(setstr(fread(fid,16,'uchar')))';
	board_type=fread(fid,1,'ushort');
	data_type=fread(fid,1,'ushort');
	coupling_type=fread(fid,1,'ushort');
	trigger_channel=fread(fid,1,'uchar');
	master_clock=fread(fid,1,'uchar');
	X_min=fread(fid,1,'long');	%in units of points
	X_max=fread(fid,1,'long');	%in units of points
	X_step=fread(fid,1,'double');
%OLD	X_unit=fread(fid,8,'char'),
        X_unit=fread(fid,8,'uchar');
	Y_min=fread(fid,1,'long');
	Y_max=fread(fid,1,'long');
	Y_step=fread(fid,1,'double');
%OLD    Y_unit=fread(fid,8,'char'),
    	Y_unit=fread(fid,8,'uchar');
	uplevel=fread(fid,1,'ushort');
	lolevel=fread(fid,1,'ushort');
	counter=fread(fid,1,'ushort');
	trigger_mode=fread(fid,1,'ushort');
	trigger_switch=fread(fid,1,'ushort');
	flags=fread(fid,1,'ushort');
	bus_config=fread(fid,1,'ulong');
	time_slow=fread(fid,1,'ulong');
	time_fast=fread(fid,1,'ulong');
	averages=fread(fid,1,'ulong');
	comment_present=fread(fid,1,'ulong');
	comment_length=fread(fid,1,'ulong');
	number_of_segments=fread(fid,1,'ulong');
	upmask=fread(fid,1,'ushort');
	lomask=fread(fid,1,'ushort');
	reserved=(setstr(fread(fid,8,'char')))';
	data_raw=fread(fid,X_max-X_min+1,'int16');
	comment=fread(fid,comment_length,'char');
	
	%creating output variables
	data(:,ichannel)=(data_raw+Y_min)*Y_step;
	time=(X_min:X_max)'*X_step;
	
	params.Software_version=identifier_version;
	switch board_type
		case 0
		 	params.board_type='T3240';
		case 1
		 	params.board_type='T1620';
		case 2
		 	params.board_type='T0410';
		case 3
		 	params.board_type='T12840';
		case 4
		 	params.board_type='T6420';
		case 5
		 	params.board_type='T512';				
		case 11
		 	params.board_type='T112';
		otherwise
			params.board_type='unkwnown board type';
	end			
	switch coupling_type
		case 0 
			params.coupling_type='DC';
		case 1 
			params.coupling_type='AC';
		case 2 
			params.coupling_type='GND';
		case 3 
			params.coupling_type='50 Ohm';
	end;	
	params.trigger_channel=trigger_channel;
	switch trigger_mode
		case 0 
			params.trigger_mode='Flanke';
		case 1 
			params.trigger_mode='Window';
		case 2 
			params.trigger_mode='Impuls';
		case 3 
			params.trigger_mode='Slew';
		case 4 
			params.trigger_mode='Period';
		case 5 
			params.trigger_mode='Extern';
		case 6
			params.trigger_mode='Coupling';
		case 7
			params.trigger_mode='Permanent';
		case 8
			params.trigger_mode='Glitch';
	end;	
	params.averages=averages;
	params.number_of_segments=number_of_segments;
	params.bit_resolution=Y_step;
end;
fclose(fid);
end