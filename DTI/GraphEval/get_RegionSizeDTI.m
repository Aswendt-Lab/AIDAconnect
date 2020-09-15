function sizeInformation = get_RegionSizeDTI(filename,connMat)

%% get_RegionSizeDTI
% This function is used by dtigroup_load.m and is not meant to be
% used manually.

niiData = load_nii(fullfile(filename.folder,filename.name));
niiVolume = niiData.img;

sizeInformation = connMat(1,:)';

regionsNo = unique(niiVolume);
%zero is background not a region - delete first item
regionsNo = regionsNo(2:end);
for i = 1:length(regionsNo)
    if ~isnan(sizeInformation(i))
        sizeInformation(i) = sum(niiVolume(:)==regionsNo(i));
    end
end
sizeInformation(sizeInformation==0) = 1;
sizeInformation = repmat(sizeInformation,1,length(sizeInformation));
sizeInformation(logical(eye(size(sizeInformation)))) = 1;
end