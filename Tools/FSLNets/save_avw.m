function save_avw(img,fname,vtype,vsize)
% SAVE_AVW(img,fname,vtype,vsize)
%
%  Create and save an analyse header (.hdr) and image (.img) file
%   for either a 2D or 3D or 4D array (automatically determined).
%  fname is the filename (must be inside single quotes)
%
%  vtype is 1 character: 'b'=unsigned byte, 's'=short, 'i'=int, 'f'=float
%                        'd'=double or 'c'=complex
%  vsize is a vector [x y z tr] containing the voxel sizes in mm and
%  the tr in seconds  (defaults: [1 1 1 3])
%
%  See also: READ_AVW
%

%% Save a temp volume in Analyze format
tmpname = tempname;

   if ((~isreal(img)) & (vtype~='c')),
     disp('WARNING:: Overwriting type - saving as complex');
     save_avw_complex(img,tmpname,vsize);
   else
     if (vtype=='c'),
       save_avw_complex(img,tmpname,vsize);
     else
       save_avw_hdr(img,tmpname,vtype,vsize);
       save_avw_img(img,tmpname,vtype);
     end
   end
         
%% Convert volume from Analyze format to user's default
tmp=sprintf('! $FSLDIR/bin/avwmaths %s %s\n',tmpname,fname);
eval(tmp);

tmp=sprintf('! /bin/rm %s.hdr %s.img \n',tmpname,tmpname);
eval(tmp);
