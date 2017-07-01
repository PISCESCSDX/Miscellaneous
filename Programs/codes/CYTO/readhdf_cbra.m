function [out,status]=readhdf(pfile,number,cfield);
%
%
% call: [out,status]=readhdf(file,number,'op_field');
%
% e.g. [out,status]=readhdf('vineta10/cyto.37',1,'Potential');
%
%
% if op_field is not set, the program lists all fields stored in 
% the hdf file 
%
% for an automatic call of the program, the output field can
% be set by op_field: possible fields are:
%

if nargin==0; help readhdf; return; end
if nargin<3 c=0; else c=1; end;


% create path and filenames
        prefix = '/mnt/vinetacode/data/CYTO/';
       	pfile=strcat(prefix,pfile);
        if number<10, file=[pfile '.00' int2str(number)]; end;
        if (number>=10 & number<100), file=[pfile '.0' int2str(number)]; end;
        if number>=100, file=[pfile '.' int2str(number)]; end;
      


% reading .hdf file

   
        % open hdf-file readonly
        sd_id=hdfsd('start',file,'rdonly');
	if sd_id==-1; error('could not open hdf file ...'); out=0; status=-1; return; end
        %
        % reading basic data information
        [ndataset,nglobal_attr,status]=hdfsd('fileinfo',sd_id);
        %

% reading global attributes

        date=hdfsd('readattr',sd_id,5);
        dz=hdfsd('readattr',sd_id,6);
        run_no=hdfsd('readattr',sd_id,7);
        run_no=double(run_no);
        time=hdfsd('readattr',sd_id,8);     
        dt=hdfsd('readattr',sd_id,9);
        end_time=hdfsd('readattr',sd_id,10);  
        mue_n=hdfsd('readattr',sd_id,14);   
        mue_w=hdfsd('readattr',sd_id,16);   
        delta=hdfsd('readattr',sd_id,18);   
        gamma=hdfsd('readattr',sd_id,20);  
        sigma=hdfsd('readattr',sd_id,22);  
        nu=hdfsd('readattr',sd_id,24);     
        limiter=hdfsd('readattr',sd_id,26); 
        kappan=hdfsd('readattr',sd_id,28); 
        nprof=hdfsd('readattr',sd_id,30);    




t=zeros(1,ndataset);

for i=0:(ndataset-1)

        sds_id=hdfsd('select',sd_id,i);
        [name,rank,dimsiz,data_type,nattr,status]=hdfsd('getinfo',sds_id);
        [a,b]=size(dimsiz);

        if b>1

                t(i+1)=1;
                narr(i+1)=cellstr(name);

        end

end;






%********************************************************************







if c==0



% output for undefined cfield in command -> choice by



mess=['        Using file ' file];
disp('------------------------------------');
disp(mess);
disp('------------------------------------');





%
disp(' field      quantity                   ');
disp('---------------------------------------');
disp(' ');
for i=0:(ndataset-1)

                if t(i+1)==1
                disp([int2str(i) narr(i+1)]);
                end



end;


% output for undefined cfield in input -> choice by

% select field
field=input('\n Input number of selected field : ');
sds_id=hdfsd('select',sd_id,field);
[name,rank,dimsiz,data_type,nattr,status]=hdfsd('getinfo',sds_id);
%
% read data

[data,status]=hdfsd('readdata',sds_id,[0,0,0],[1,1,1],dimsiz);
hdfsd('endaccess',sds_id);

mess=['-> -> -> selected output field:  ' name];
disp(mess);
data=double(data);



else
       for i=0:(ndataset-1)

                p=strcmp(narr(i+1),cfield);
                if p==1 ci=i; break; end;
       end

        sds_id=hdfsd('select',sd_id,ci);
        [name,rank,dimsiz,data_type,nattr,status]=hdfsd('getinfo',sds_id);
        [data,status]=hdfsd('readdata',sds_id,[0,0,0],[1,1,1],dimsiz);
        hdfsd('endaccess',sds_id);
        data=double(data);

end


%get coordinates -z 
 sds_id=hdfsd('select',sd_id,1);
[name,rank,dimsiz,data_type,nattr,status]=hdfsd('getinfo',sds_id);
[z,status]=hdfsd('readdata',sds_id,[0],[1],dimsiz);
hdfsd('endaccess',sds_id);

%get coordinates -phi
sds_id=hdfsd('select',sd_id,2);
[name,rank,dimsiz,data_type,nattr,status]=hdfsd('getinfo',sds_id);
[phi,status]=hdfsd('readdata',sds_id,[0],[1],dimsiz);
hdfsd('endaccess',sds_id);

%get coordinates -phi
sds_id=hdfsd('select',sd_id,3);
[name,rank,dimsiz,data_type,nattr,status]=hdfsd('getinfo',sds_id);
[r,status]=hdfsd('readdata',sds_id,[0],[1],dimsiz);
hdfsd('endaccess',sds_id);




out.data=data;
out.time=time;
out.r=r;
out.phi=phi;
out.z=z;


status = hdfsd('end',sd_id);










