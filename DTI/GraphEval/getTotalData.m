function [OutStruct]=getTotalData(inputDTI)

%% getTotalData
% This function is used by several scripts and is not meant to be
% used manually. It merges all given DTI-connectivity-MAT-Files.

path  = inputDTI.out_path;
groups = inputDTI.groups;
days = inputDTI.days;
tempFile = load('../Tools/infoData/acronyms_splitted.mat');
acronyms = tempFile.acronyms;

numOfRegions = length(inputDTI.index);
index = inputDTI.index;

TotalData=nan*ones(numOfRegions,numOfRegions ,10,length(days),length(groups));
Cat=[];

for d = 1:length(days)
    for g = 1:length(groups)
        cur_path = char(fullfile(path,groups(g)));
        matFile_cur = ([cur_path '/' char(days(d)) '.mat']);
        load(matFile_cur, 'infoDTI');             
        [p, q, o]=size(infoDTI.matrix(index,index,:));       
        TotalData(1:p,1:q,1:o,d,g)=squeeze(infoDTI.matrix(index,index,:)); 
    end
end
OutStruct.Data=TotalData;
OutStruct.Category=Cat;
OutStruct.Indices=index;
OutStruct.Acronym=acronyms(index);

end