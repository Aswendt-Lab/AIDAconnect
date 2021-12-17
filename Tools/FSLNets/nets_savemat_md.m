%
% nets_savemat_md(ts_dir,mat,mat_name);
% niklasp - 20180528
%
% save matrix as text file
%

function storedFile = nets_savemat_md(ts_dir,folder,mat,mat_name)

%fname=strsplit(pwd(),filesep);
fname=strsplit(ts_dir,'_');
fname=strcat(mat_name,'_',erase(fname(end),'.txt.mat'),'.txt');
fname=fullfile(folder,fname);
fname= fname{1};
disp(fname);
dlmwrite(fname,mat,'delimiter','\t','precision','%.8f');
storedFile = fname;
