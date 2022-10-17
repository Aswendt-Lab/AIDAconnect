%%
clc
clear
close all
% User input: Raw_data_folder
Alldata = "N:\Student_projects\14_Aref_Kalantari_2021\Projects\CRC_WP1\Codes\Windows_AIDAconnect-master\fMRI\**\*.m"
files = dir(Alldata);

for ii = 1:length(files)

Mfile= fullfile(files(ii).folder,files(ii).name);
text = fileread(Mfile);
newtext = replace(text,".\","./");
fid = fopen(Mfile,'w');    % open file for writing (overwrite if necessary)
fprintf(fid,'%s',newtext);          % Write the char array, interpret newline as new line
fclose(fid); 
end
