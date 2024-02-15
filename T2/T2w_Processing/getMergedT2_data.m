function getMergedT2_data(t2Struct)

path  = t2Struct.in_path;
groups = t2Struct.groups;
subdirs = t2Struct.subdirs;
days = t2Struct.days;
out_path = t2Struct.out_path;
groupmapping = readtable(fullfile(path, "GroupMapping.xlsx"));

% number of regions
numOfRegions = 49;


for g = 1:length(groups)
    cur_group = groups(g);
    for d = 1:length(days)
        all_mat_files = cell(1, 0);
        groupsubject = 1;
        for s = 1:height(groupmapping)
            subname = groupmapping(s,:).Subject{1};
            group = groupmapping(s,:).Group{1};
            if group ~= cur_group
                continue
            end
            disp('Processing '+days(d)+': '+ subname+' ...');       
            cur_path = char(fullfile(path,subname,"ses-"+days(d)));
            if ~isfolder(cur_path)
                disp(cur_path + " does not exist");
                continue
            end
            matFile_cur = dir([cur_path '/anat/labelCount_par.mat']);
            if isempty(matFile_cur)
                continue
            end
            all_mat_files{groupsubject} = matFile_cur;

            groupsubject = groupsubject + 1;
        end

        if length(all_mat_files)<1
            continue
        end

        infoT2 =struct();
        namesOfMat = cell(length(all_mat_files),1);
        lesionSize_mm =     zeros(length(all_mat_files),1); 
        lesionSize_percent =   zeros(length(all_mat_files),1); 
        affectedRegions_percent =   zeros(length(all_mat_files),numOfRegions);

        for i = 1:length(all_mat_files)
            matFile_cur = all_mat_files{i};
            
            tempName = split(all_mat_files{i}.folder,filesep);
            tempName = tempName(end-2:end-1);
            tempName = strjoin(tempName,"_");
            namesOfMat{i} = tempName;
            curMatFile = load(fullfile(matFile_cur.folder,matFile_cur.name));
            cur_labels =  string(strcat(curMatFile.ABAlabels));
            cur_affectedLabels = string(strcat(curMatFile.ABANamesPar));
            
            affectedRegions_percent(i,contains(cur_labels,cur_affectedLabels))=curMatFile.ABLAbelsIDsParental(2,:)';
            lesionSize_mm(i) = curMatFile.volumeMM;
            lesionSize_percent(i) = curMatFile.volumePer;
            
        end
        if length(all_mat_files)>=1
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
            disp(strcat(targetPath,filesep,days(d),groups(g),'.mat'))
            disp(infoT2.names)
            save(strcat(targetPath,filesep,days(d),groups(g),'.mat'),'infoT2')
        end
    end
    
end


end