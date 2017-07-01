README for rigidBody.m

MAJOR VERSION CHANGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
OUTPUT MATRICES ARE NOW ABSOLUTE (NOT RELATIVE TRANSFORMS) IF YOU HAVE 
DOWNLOADED THIS VERSION, YOU SHOULD ALSO DOWNLOAD THE LATEST MAYA TOOLS
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


what you need:
1. a markercoordinates.csv file 3 columns for each marker (xyz coordinates)
2. an *xyzpts.csv file from digitized data

Note: 	The number of columns must be a perfect match between the two files.
	if you have 10 markers - you must have 30 columns in both files. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

You may want to filter *xyzpts* data prior to calculating rigid body motion

Filter Procedure
1. type butterBatch at the matlab prompt
2. enter the cutoff frequency, recording frequency, and filter type
	(default 25, 250, low - other filter types are high, stop, pass)
3. select 1 or more files to process
4. files are saved in the original directory with BUTTER## appended to the 
	end of the original file name. The ## specifies the cutoff frequency 

Note: 	a spline interpolation will fill NaN gaps of less than 20 frames

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
Rigid Body Motion Procedure
1. type rigidBody at the matlab prompt
2. select *xyzpts*.csv file
3. select markercoords.csv file
4. type the number of bones in the input box
5. select the markers associated with each bone
6. save the file output. 
7. To use this file in maya, either click the imMtx button in the XROMM_tools 
	shelf or type impMatrix at the command line



Note: 	After you run through steps 1-6 in matlab, the variables markerIdx and ct 
	are stored in the workspace. If you need to do subsequent reconstructions, 
	simply type rigidBody(markerIdx,ct) at the matlab prompt. This will elimate 
	steps 3-5.

Other details:
	rigidBody calls 2 additional scripts: svdrigid and mayaMatrixFormat

	svdrigid converts marker data for a single bone and outputs relative rotations
	and translations for each frame.

	mayaMatrixFormat converts the nx3x3 rotation matrices or nx4x4 transformation matrices 
	and nx3 translations to a nx16 rotation matrix in a maya friendly format 
	(n specifies the number of frames).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Version details

1.1.0

Output is now absolute transformations. All prior versions were relative transformations. The latest update of the maya shelf tool allows you to choose absolute or relative. For all versions older than 
1.1, use relative. For all versions 1.1.0 and higher, choose absolute in maya.

added scripts:
RTto4x4.m
% function [Transf] = RTto4x4(R, T)
%
% Inputs:  R = 3x3 rotation matrix
%          T = xyz translation
% Output:  Transf = 4x4 tranformation matrix


indexNonNan.m
% function [consecutiveIdxSequences, gapAfter, startend] = indexNonNan(col)
% Inputs:   col = a single column of data 
% Outputs:  consecutiveIdxSequence =  cell array where each cell contains 
%               the index numbers of a consecutive sequence from the input
%               NaN gaps of less than 20 will be interpolated across by 
%               default. Change the number 20 below if you desire a 
%               different gap cutoff.
%           gapAfter = number of NaN rows after each sequence
%           startend = nx2 matrix of the start and end row of each sequence
% David Baier
% last updated: 2/26/2009
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  1.1.1
% Bug fixed in butterBatch.m
% updated: 5/07/2009
%	