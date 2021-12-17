%
% nets_fslmeants_md - load a folder full of individual runs'/subjects' node-timeseries files
% michaeld, 2016-09-05
%
% ts = nets_fslmeants_md(indir,pythonscript,prefix,suffix,seed_prefix,seed_suffix);
%

function nets_fslmeants_md(pathOfdata,data_prefix,seed_prefix)

dataList = dir(fullfile(pathOfdata, [data_prefix '*']));
seedList = dir(fullfile(pathOfdata, [seed_prefix '*']));

if size(dataList) ~= size(seedList)
    error("Error: Number of seed data not equal to input data")
end


Nsubjects=size(seedList,1);
for i=1:Nsubjects
    seed_mask=fullfile(seedList(i).folder,seedList(i).name);
    dataName = fullfile(dataList(i).folder,dataList(i).name);
    disp(seed_mask);
    fsl_mean_ts(dataName,seed_mask);
end



