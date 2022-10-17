function getMergedFMRI_data(fmriStruct,thres_type,thres)

%% getMergedFMRI_data
% This function is used by mergeFMRIdata_input.m and is not meant to be
% used manually. It merges all given rsfMRI-connectivity-.mat-files. 

addpath('..\Tools\BCT');
path  = fmriStruct.in_path;
groups = fmriStruct.groups;
days = fmriStruct.days;
out_path = fmriStruct.out_path;
% initialize counter for the number of regions
numOfRegions_all(1) = 0; 
j = 2;
for d = 1:length(days)
    for g = 1:length(groups)
        disp('Processing '+days(d)+': '+groups(g)+' ...');       
        cur_path = char(fullfile(path,days(d),groups(g)));
        matFile_cur = dir([cur_path '\*\fMRI\regr\MasksTCsSplit*txt.mat']);
        % Random Sample Check
        randomSubject = randsample(1:size(matFile_cur,1),1);
        randomSubjectPath = strcat(matFile_cur(randomSubject,1).folder,'\',matFile_cur(randomSubject,1).name);
        matFile_cur_temp = load(randomSubjectPath);
        numOfRegions_all(j) = size(matFile_cur_temp.label,1);
        if j-1 ~= 1 && numOfRegions_all(j) ~= numOfRegions_all(j-1)
            disp('Warning: Number of atlas labels differs between two subjects, groups or days!');
        end
        % Create infoFMRI struct
        numOfRegions = unique(numOfRegions_all(2:end));
        % numOfRegions_all should contain a 0 in position 1.
        % All subsequent positions should contain the number of atlas
        % labels, which should always result in the same number.
        % If not, then line 36 will cause an error because the numOfRegions
        % is not unique anymore. A quick solution is then to specify
        % a concrete number in line 29 for numOfRegions, e.g. 98.
        infoFMRI = struct();
        coMat = zeros(numOfRegions,numOfRegions,length(matFile_cur));
        namesOfMat = cell(length(matFile_cur),1);
        clustercoef =               zeros(length(matFile_cur),numOfRegions); 
        clustercoef_rand =          zeros(length(matFile_cur),numOfRegions);
        clustercoef_normalized =    zeros(length(matFile_cur),numOfRegions);
        participationcoef =         zeros(length(matFile_cur),numOfRegions);
        degrees =                   zeros(length(matFile_cur),numOfRegions); 
        strengths =                 zeros(length(matFile_cur),numOfRegions); 
        betweenness =               zeros(length(matFile_cur),numOfRegions); 
        centrality_eigen =          zeros(length(matFile_cur),numOfRegions);
        localEfficiency =           zeros(length(matFile_cur),numOfRegions);
        density =                   nan(1,length(matFile_cur));
        transitivity =              nan(1,length(matFile_cur));
        efficiency =                nan(1,length(matFile_cur));
        efficiency_rand =           nan(1,length(matFile_cur));
        assortativity =             nan(1,length(matFile_cur));
        modularity =                nan(1,length(matFile_cur));
        charPathLength=             nan(1,length(matFile_cur));
        charPathLength_rand =       nan(1,length(matFile_cur));
        charPathLength_normalized = nan(1,length(matFile_cur));
        overallConnectivity =       zeros(1,length(matFile_cur));
        
        if length(matFile_cur)<1
            error('There is no content in the given path!');
        end
        
        for i = 1:length(matFile_cur) % i = Subjects
            tempName = strsplit(matFile_cur(i).folder,filesep);
            tempName = strsplit(string(tempName(end-2)),'_');
            tempName = strjoin(tempName(1:4),'_');
            namesOfMat{i} = tempName;
            
            [coMat(:,:,i),labels] = matrixMaker_rsfMRI((fullfile(matFile_cur(i).folder,matFile_cur(i).name)));
            current_matAll = abs(coMat); % Absolute values of the matrices
            
            % Threshold for correlations
            switch(thres_type)
                case 0 % Fixed threshold
                    current_matAll(current_matAll<thres) = 0; 
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
            
            % The calculation of betweenness centrality only 
            % works with connection length matrices.
            % The inverse matrix is some kind of connection length matrix:
            % High correlations result in short distances.
            % Random networks are used to normalize the smallWorldness
            % metric
            
            current_mat_inverse = 1./current_mat;
            randomNetwork = randmio_und_connected(current_mat, 5);
           
            % Local parameters for each region using graph theory (BCT)
            clustercoef(i,:) =  clustering_coef_wu(current_mat);
            clustercoef_rand(i,:) = clustering_coef_wu(randomNetwork);
            [communityAffiliationVector,~] = community_louvain(current_mat,1);
            % The community affiliation vector assigns nodes to specific,
            % non-overlapping modules and is a necessary parameter for the
            % participation coefficient
            participationcoef(i,:) = participation_coef(current_mat,communityAffiliationVector,0);
            degrees(i,:) =      degrees_und(current_mat)';
            strengths(i,:) =    strengths_und(current_mat)';
            betweenness(i,:) =  betweenness_wei(current_mat_inverse);           
            centrality_eigen(i,:) =   eigenvector_centrality_und(current_mat); 
            localEfficiency(i,:) = efficiency_wei(current_mat,2);
            
          
            % Global parameters for each subject using graph theory (BCT)
            density(i) = density_und(current_mat);
            transitivity(i) = transitivity_wu(current_mat);
            efficiency(i) = efficiency_wei(current_mat);
            efficiency_rand(i) = efficiency_wei(randomNetwork);
            assortativity(i) = assortativity_wei(current_mat,0);           
            charPathLength(i) = 1./efficiency(i);
            charPathLength_rand(i) = 1./efficiency_rand(i);
            
            if sum(current_mat(:))==0
                modularity(i) = 0;
                disp(['The matrix of the study number ' tempName ' contains only zero values!'])
            else
                [~,modularity(i)] = modularity_und(current_mat,1);
            end
                   
        end
        infoFMRI.group = groups(g);
        infoFMRI.day = days(d);
        infoFMRI.names = namesOfMat;
        infoFMRI.matrix = current_matAll;
        infoFMRI.labels = labels;
        infoFMRI.clustercoef = clustercoef;
        infoFMRI.participationcoef = participationcoef;
        infoFMRI.degrees = degrees;
        infoFMRI.strengths = strengths;
        infoFMRI.betw_centrality = betweenness;
        infoFMRI.eign_centrality = centrality_eigen;
        infoFMRI.localEfficiency = localEfficiency;
        infoFMRI.density = density;
        infoFMRI.transitivity = transitivity;
        infoFMRI.efficiency = efficiency;
        infoFMRI.assortativity = assortativity;
        infoFMRI.modularity = modularity;
        infoFMRI.charPathLength = charPathLength;
        
        % Normalizing smallWorldness using random networks:
        % clustercoeff(:,i) returns a matrix for the given subject i
        % charPathLength(i) returns a value for the given subject i
        % Both metrics are normalized dividing by the metric values
        % of a random network.
        % If smallWorldness > 1 then the network can be labeled as "small world".
        
        clustercoef_normalized(:,i) = nanmean(clustercoef(:,i),2)./nanmean(clustercoef_rand(:,i),2);
        charPathLength_normalized(i) = charPathLength(i)/charPathLength_rand(i);        
        infoFMRI.smallWorldness = (clustercoef_normalized(:,i)/charPathLength_normalized(i))';
        infoFMRI.overallConnectivity = overallConnectivity;
        
        %infoFMRI.smallWorldness = (nanmean(clustercoef(:,i),2)\charPathLength(i))';
   
        targetPath = fullfile(out_path,groups(g));
        if ~exist(targetPath,'dir')
            mkdir(targetPath);
        end
        disp(strcat(targetPath,filesep,days(d),'.mat'))
        disp(infoFMRI.names)
        save(strcat(targetPath,filesep,days(d),'.mat'),'infoFMRI')
        j = j+1;
    end
end

end