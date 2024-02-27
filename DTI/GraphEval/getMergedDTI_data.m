function getMergedDTI_data(dtiStruct,thres_type,thres)

%% getMergedDTI_data
% This function is used by mergeFMRIdata_input.m and is not meant to be
% used manually. It merges all given DTI-connectivity-.mat-files. 

addpath('../Tools/BCT');
path  = dtiStruct.in_path;
groups = dtiStruct.groups;
groupmapping = readtable(fullfile(path, "GroupMapping.xlsx"));
days = dtiStruct.days;
out_path = dtiStruct.out_path;
tempF = load('../Tools/infoData/acro_numbers_splitted.mat');
acroNum = tempF.annotationsNumber;
numOfRegions = size(acroNum,1);

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
            
            matFile_cur = dir([cur_path '/dwi/connectivity/*AnnoSplit_parental*pass.connectivity.mat']);
            if isempty(matFile_cur)
                continue
            end

            all_mat_files{groupsubject} = matFile_cur;

            groupsubject = groupsubject + 1;

        end

        if length(all_mat_files)<1
            disp('There is no content in the given path!');
            continue
        end
    
        infoDTI = struct();
        coMat=zeros(numOfRegions,numOfRegions,length(all_mat_files));
        namesOfMat = cell(length(all_mat_files),1);
        clustercoef =               zeros(length(all_mat_files),numOfRegions);  
        clustercoef_rand =          zeros(length(all_mat_files),numOfRegions);
        clustercoef_normalized =    zeros(length(all_mat_files),numOfRegions);
        participationcoef =         zeros(length(all_mat_files),numOfRegions);
        degrees =                   zeros(length(all_mat_files),numOfRegions); 
        strengths =                 zeros(length(all_mat_files),numOfRegions); 
        betweenness =               zeros(length(all_mat_files),numOfRegions); 
        centrality =                zeros(length(all_mat_files),numOfRegions);
        localEfficiency =           zeros(length(all_mat_files),numOfRegions);
        density =                   nan(1,length(all_mat_files));
        transitivity =              nan(1,length(all_mat_files));
        efficiency =                nan(1,length(all_mat_files));
        efficiency_rand =           nan(1,length(all_mat_files));
        assortativity =             nan(1,length(all_mat_files));
        modularity =                nan(1,length(all_mat_files));
        charPathLength =            nan(1,length(all_mat_files));
        charPathLength_rand =       nan(1,length(all_mat_files));
        charPathLength_normalized = nan(1,length(all_mat_files));
        overallConnectivity =       zeros(1,length(all_mat_files));
             
        ad = nan(length(all_mat_files),numOfRegions);
        fa0 = nan(length(all_mat_files),numOfRegions);
        md = nan(length(all_mat_files),numOfRegions);
        rd = nan(length(all_mat_files),numOfRegions);
        
        for i = 1:length(all_mat_files) % i = Subjects
            matFile_cur = all_mat_files{i};
            cur_path = matFile_cur.folder;
            [cur_path, ~, ~] = fileparts(cur_path);
            cur_path = fileparts(cur_path);
            
            adfile_cur = dir([cur_path '/dwi/DSI_studio/*ad.nii.gz']);
            fa0file_cur = dir([cur_path '/dwi/DSI_studio/*fa.nii.gz']);
            mdfile_cur = dir([cur_path '/dwi/DSI_studio/*md.nii.gz']);
            rdfile_cur = dir([cur_path '/dwi/DSI_studio/*rd.nii.gz']);
            arafile_cur = dir([cur_path '/dwi/DSI_studio/*AnnoSplit_parental_scaled.nii']);

            tempName = matFile_cur.name;
            tempName = strsplit(tempName,'_');
            tempName = strjoin(tempName(1),'_');
            namesOfMat{i} = tempName;
            
            [coMat(:,:,i),labels] = matrixMaker_DTI((fullfile(matFile_cur.folder,matFile_cur.name)),0);
            current_matAll = coMat;
            % Remove negative values in the matrices (just in case)
            current_matAll(current_matAll<=0) = 0;
            infoDTI.raw_matrix = current_matAll;
            
            % Apply the threshold for the number of fibers
            switch(thres_type)
                case 0 % Fixed threshold
                    threshold = mean(current_matAll)*thres;
                    current_matAll(current_matAll<threshold) = 0;
                case 1 % Density-based threshold
                    current_matAll(:,:,i) = threshold_proportional(current_matAll(:,:,i),thres);
            end
         
            % Ensure there are no self-connections
            for ii = 1:size(current_matAll,1)
                current_matAll(ii,ii,i) = 0;
            end 
            current_mat = current_matAll(:,:,i);
            overallConnectivity(i) = mean(current_mat, 'all');
            
            % Hint: 
            % The calculations of the following metrics using BCT
            % do not allow negative values:
            % Local: efficiency, clustering_coeff, betweenness and
            % Global: efficiency, transitivity, charPathLength 
            
            % Some measures of the BCT only work with normalized data
            % (0-1). The calculation of betweenness centrality only 
            % works with connection length matrices.
            % The inverse matrix is some kind of connection length matrix:
            % High numbers of fibers result in short distances.
            % Random networks are used to normalize the smallWorldness
            % metric.

            current_mat_normalized = weight_conversion(current_mat, 'normalize');
            current_mat_inverse = 1./current_mat;
            randomNetwork = randmio_und_connected(current_mat_normalized, 5);
            
            % Local parameters for each region using graph theory (BCT)
            clustercoef(i,:) =  clustering_coef_wu(current_mat_normalized);
            clustercoef_rand(i,:) = clustering_coef_wu(randomNetwork);
            [communityAffiliationVector,~] = community_louvain(current_mat,1);
            % The community affiliation vector assigns nodes to specific,
            % non-overlapping modules and is a necessary parameter for the
            % participation coefficient
            participationcoef(i,:) = participation_coef(current_mat,communityAffiliationVector,0);
            degrees(i,:) =      degrees_und(current_mat)';
            strengths(i,:)=     strengths_und(current_mat)';
            betweenness(i,:) =  betweenness_wei(current_mat_inverse);
            centrality(i,:) =   eigenvector_centrality_und(current_mat);
            localEfficiency(i,:) = efficiency_wei(current_mat_normalized,2);
            
            % Global parameters for each subject using graph theory (BCT)
            density(i) = density_und(current_mat);
            transitivity(i) = transitivity_wu(current_mat_normalized);
            assortativity(i) = assortativity_wei(current_mat,0);
            efficiency(i) = efficiency_wei(current_mat_normalized);
            efficiency_rand(i) = efficiency_wei(randomNetwork);
            charPathLength(i) = 1./efficiency(i); 
            charPathLength_rand(i) = 1./efficiency_rand(i);

            if sum(current_mat(:))==0
                modularity(i) = 0;
                disp(['The matrix of the study number ' tempName ' contains only zero values!'])
            else
                [~,modularity(i)] = modularity_und(current_mat,1);
            end
           
            % Get AD, FA0, RD and MD values and add them to the given struct
            adNii = load_nii(fullfile(adfile_cur.folder,adfile_cur.name));
            fa0Nii = load_nii(fullfile(fa0file_cur.folder,fa0file_cur.name));
            mdNii = load_nii(fullfile(mdfile_cur.folder,mdfile_cur.name));
            rdNii = load_nii(fullfile(rdfile_cur.folder,rdfile_cur.name));
            araNii = load_nii(fullfile(arafile_cur.folder,arafile_cur.name));
            adimg = adNii.img;
            fa0img = fa0Nii.img;
            mdimg = mdNii.img;
            rdimg = rdNii.img;
            araimg = araNii.img;
            for r = 1:numOfRegions
                ad(i,r)=mean(adimg(araimg==acroNum(r)));
                fa0(i,r)=mean(fa0img(araimg==acroNum(r)));
                md(i,r)=mean(mdimg(araimg==acroNum(r)));
                rd(i,r)=mean(rdimg(araimg==acroNum(r)));
            end                

        end

       

        infoDTI.group = groups(g);
        infoDTI.day = days(d);
        infoDTI.names = namesOfMat;
        infoDTI.matrix = coMat;
        infoDTI.labels = labels;
        infoDTI.clustercoef = clustercoef;
        infoDTI.participationcoef = participationcoef;
        infoDTI.degrees = degrees;
        infoDTI.strengths = strengths;
        infoDTI.betw_centrality = betweenness;
        infoDTI.eign_centrality = centrality;
        infoDTI.localEfficiency = localEfficiency;
        infoDTI.density = density;
        infoDTI.transitivity = transitivity;
        infoDTI.efficiency = efficiency;
        infoDTI.assortativity = assortativity;
        infoDTI.modularity = modularity;
        infoDTI.charPathLength = charPathLength;
        infoDTI.thres = thres;
        infoDTI.thres_type = thres_type;
        
        % Normalizing smallWorldness using random networks:
        % clustercoeff(:,i) returns a matrix for the given subject i
        % charPathLength(i) returns a value for the given subject i
        % Both metrics are normalized dividing by the metric values
        % of a random network.     
        % If smallWorldness > 1 then the network can be labeled as "small world".
        
        clustercoef_normalized(:,i) = nanmean(clustercoef(:,i),2)./nanmean(clustercoef_rand(:,i),2);
        charPathLength_normalized(i) = charPathLength(i)/charPathLength_rand(i);        
        infoDTI.smallWorldness = (clustercoef_normalized(:,i)/charPathLength_normalized(i))';
        infoDTI.overallConnectivity = overallConnectivity;
        
        %infoDTI.smallWorldness = (nanmean(clustercoef(:,i),2)/charPathLength(i))';
        
        infoDTI.AD  = ad;
        infoDTI.FA0 = fa0;
        infoDTI.MD  = md; 
        infoDTI.RD  = rd;
   
        targetPath = fullfile(out_path,groups(g));
        if ~exist(targetPath,'dir')
            mkdir(targetPath);
        end   
        disp(strcat(targetPath,filesep,days(d),"_",groups(g),'.mat'))
        disp(infoDTI.names)
        save(strcat(targetPath,filesep,days(d),"_",groups(g),'.mat'),'infoDTI')
    end
end




end