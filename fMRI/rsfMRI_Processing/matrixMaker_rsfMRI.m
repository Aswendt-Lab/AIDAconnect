function [mNet,labelsData] = matrixMaker_rsfMRI(mat_file,varargin)

%% matrixMaker_rsfMRI
% This function is used by getMergedFMRI_data.m and is not meant to be
% used manually. It creates matrices from raw .mat-files of the
% rsfMRI-measurement.

addpath('../Tools/FSLNets')                  
addpath('../Tools/BCT');

if nargin==2
    var_plot=varargin{1};
else
    var_plot=0;
end

dirInfos = dir(mat_file);
targetFolder = strrep(dirInfos.folder,'regr','activity');
[~, ~, ~] = mkdir(targetFolder);

data=load(mat_file);
funcmat = double(data.matrix);

% data to calculate correlation
ts.ts=funcmat;
ts.tr=1.42;
ts.Nsubjects=1;
ts.Nnodes=size(funcmat,2);
ts.NnodesOrig=ts.Nnodes;
ts.Ntimepoints=size(funcmat,1);
ts.NtimepointsPerSubject=size(funcmat,1);
ts.DD=1:ts.Nnodes;
ts.UNK=[];

netmats = nets_netmats_md(ts,0,0,'corr');
 
mNet = reshape(netmats(1,:),[sqrt(length(netmats)) sqrt(length(netmats))]);
%matStd = mean(std(mNet));
%mNet = threshold_absolute(mNet,matStd/2); 
%% labels string2char
labelMat = data.label;
labelsData = cell(1,size(labelMat,1));
for i =  1:size(labelMat,1)
    k = labelMat(i,:);
    strData = strsplit(k,'\n');
    strTemp = strData{1};
    strData = strsplit(strTemp,'\t');
    labelName = strData{2};
    labelName = strrep(labelName,'_',' ');
    labelsData{i} = labelName;
end
labelsData{end} = labelName(1:end-8);

end




