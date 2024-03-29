function [groupInfo,name] = dtigroup_load(indir,prefix)

%% dtigroup_load
% This function is used by matrixMaker_DTI.m and is not meant to be
% used manually.

addpath('../Tools/BCT');
groupInfo.name = [];
d=dir(strcat(fullfile(indir,prefix),'*connectivity.mat'));
Nsubjects=size(d,1);

if contains(prefix,'AnnoSplit_parental')
    dataTemplate=load('../Tools/infoData/annoVolume+2000_rsfMRI.mat');
    refLabels = dataTemplate.annoVolume2000rsfMRI;
    annotations2getSize=dir(fullfile(fileparts(indir),'*AnnoSplit_parental.nii.gz'));
elseif contains(prefix,'parental')
    dataTemplate=load('../Tools/infoData/annoVolume.mat');
    refLabels = dataTemplate.annoVolume;
    annotations2getSize=dir(fullfile(fileparts(indir),'*Anno_parental.nii.gz'));     
else
    dataTemplate=load('../Tools/infoData/labelsNames.mat');
    refLabels = dataTemplate.ARAannotationR2000;
    annotations2getSize=dir(fullfile(fileparts(indir),'*AnnoSplit.nii.gz'));
end

TS =zeros(length(refLabels),length(refLabels),Nsubjects/2);
for i=1:2:Nsubjects
    name = strsplit(d(i).name,'.');
    name = name(1);
    
    groupInfo.name = [groupInfo.name name];
    tdata= load(fullfile(d(i).folder,d(i).name));
    connPass = tdata.connectivity;
    tdata = load(fullfile(d(i+1).folder,d(i+1).name));
    connEnd = tdata.connectivity;
    
    connectivity = connPass+connEnd;
    labels = textscan(char(tdata.name),'%s');

    % Create custom node labels
    % myLabel = cell(length(annoVolume2000rsfMRI),1);
    curLabels = string(labels{1});
    [~,ia] =intersect(refLabels,curLabels);
    missingLabels = setxor(sort(ia),1:length(refLabels));
    c_refLabels=strrep(refLabels,'_',' ');
    myLabel = cellstr(c_refLabels);
    zeroVec = zeros(length(refLabels),length(refLabels));
    zeroVec(sort(ia),sort(ia))= connectivity;
    % Normalize connectivity matrix by number of atlas labels
    connectivityFilled = zeroVec;
     
    %matStd = mean(std(connectivityFilled)); 
    %connectivityFilled = threshold_absolute(connectivityFilled,matStd/2); 
    sizeMatrix = get_RegionSizeDTI(annotations2getSize(ceil(i/2)),connectivityFilled)/10;
    connectivityFilled = ceil(connectivityFilled/mean(connectivityFilled(connectivityFilled>0))*100);%.*sizeMatrix);
   
    TS(:,:,ceil(i/2)) = connectivityFilled;
  
end

groupInfo.mergedMat=TS;
groupInfo.labels = myLabel;
groupInfo.regionSizes = sizeMatrix;


