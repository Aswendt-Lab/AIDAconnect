function getMergedT2_data(t2Struct)

path  = t2Struct.in_path;
groups = t2Struct.groups;
days = t2Struct.days;
out_path = t2Struct.out_path;

% number of regions
numOfRegions = 49;


for d = 1:length(days)
    for g = 1:length(groups)
        cur_path = char(fullfile(path,days(d),groups(g)));
        matFile_cur = dir([cur_path '/*/T2w/labelCount_par.mat']);
        infoT2 =struct();
        namesOfMat = cell(length(matFile_cur),1);
        lesionSize_mm =     zeros(length(matFile_cur),1); 
        lesionSize_percent =   zeros(length(matFile_cur),1); 
        affectedRegions_percent =   zeros(length(matFile_cur),numOfRegions); 
        for i = 1:length(matFile_cur)
            tempName = split(matFile_cur(i).folder,filesep);
            tempName = tempName(end-1);
            tempName = split(tempName,'_');
            tempName = strjoin(tempName(1:4),'_');
            namesOfMat{i} = tempName;
            curMatFile = load(fullfile(matFile_cur(i).folder,matFile_cur(i).name));
            cur_labels =  string(strcat(curMatFile.ABAlabels));
            cur_affectedLabels = string(strcat(curMatFile.ABANamesPar));
            
            affectedRegions_percent(i,contains(cur_labels,cur_affectedLabels))=curMatFile.ABLAbelsIDsParental(2,:)';
            lesionSize_mm(i) = curMatFile.volumeMM;
            lesionSize_percent(i) = curMatFile.volumePer;
            
        end
        if length(matFile_cur)>1
            infoT2.group = groups(g);
            infoT2.day = days(d);
            infoT2.names = namesOfMat;
            infoT2.labels = cur_labels;
            infoT2.lesionSize_mm = lesionSize_mm;
            infoT2.lesionSize_percent = lesionSize_percent;
            infoT2.affectedRegions_percent = affectedRegions_percent;

            targetPath = fullfile(out_path,groups(g));
            if ~exist(targetPath,'dir')
                mkdir(targetPath);
            end   
            disp(strcat(targetPath,filesep,days(d),'.mat'))
            disp(infoT2.names)
            save(strcat(targetPath,filesep,days(d),'.mat'),'infoT2')
        end
    end
end


end