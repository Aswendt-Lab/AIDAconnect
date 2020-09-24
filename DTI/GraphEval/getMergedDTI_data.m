function getMergedDTI_data(dtiStruct,thres)

%% getMergedDTI_data
% This function is used by mergeFMRIdata_input.m and is not meant to be
% used manually. It merges all given DTI-connectivity-.mat-files. 

addpath('../Tools/BCT');
path  = dtiStruct.in_path;
groups = dtiStruct.groups;
days= dtiStruct.days;
out_path=dtiStruct.out_path;
% number of regions
tempF = load('../Tools/infoData/acro_numbers_splitted.mat');
acroNum = tempF.annotationsNumber;
numOfRegions = 98;

for d = 1:length(days)
    for g = 1:length(groups)
        cur_path = char(fullfile(path,days(d),groups(g)));
        matFile_cur = dir([cur_path '/*/DTI/connectivity/*rsfMRISplit*pass.connectivity.mat']);
        infoDTI =struct();
        coMat=zeros(numOfRegions,numOfRegions,length(matFile_cur));
        namesOfMat = cell(length(matFile_cur),1);
        clustercoef =   zeros(length(matFile_cur),numOfRegions);  
        degrees =       zeros(length(matFile_cur),numOfRegions); 
        strengths =     zeros(length(matFile_cur),numOfRegions); 
        betweenness =   zeros(length(matFile_cur),numOfRegions); 
        centrality =    zeros(length(matFile_cur),numOfRegions);
        density =       nan(1,length(matFile_cur));
        transitivity =  nan(1,length(matFile_cur));
        efficiency =    nan(1,length(matFile_cur));
        assortativity = nan(1,length(matFile_cur));
        modularity =    nan(1,length(matFile_cur));
        charPathLength= nan(1,length(matFile_cur));
        
        if length(matFile_cur)<1
            error('There is no content in the given path!');
        end
              
        adfile_cur = dir([cur_path '/*/DTI/DSI_studio/*ad.nii.gz']);
        fa0file_cur = dir([cur_path '/*/DTI/DSI_studio/*fa0.nii.gz']);
        mdfile_cur = dir([cur_path '/*/DTI/DSI_studio/*md.nii.gz']);
        rdfile_cur = dir([cur_path '/*/DTI/DSI_studio/*rd.nii.gz']);
        arafile_cur = dir([cur_path '/*/DTI/DSI_studio/*rsfMRISplit_scaled.nii.gz']);
        ad = nan(length(matFile_cur),numOfRegions);
        fa0 = nan(length(matFile_cur),numOfRegions);
        md = nan(length(matFile_cur),numOfRegions);
        rd = nan(length(matFile_cur),numOfRegions);
        
        for i = 1:length(matFile_cur)
            tempName = matFile_cur(i).name;
            tempName = strsplit(tempName,'_');
            tempName = strjoin(tempName(1:4),'_');
            namesOfMat{i} = tempName;
            
            [coMat(:,:,i),labels] = matrixMaker_DTI((fullfile(matFile_cur(i).folder,matFile_cur(i).name)),0);
            current_matAll=coMat;
            current_matAll(abs(coMat)<thres*mean(abs(coMat)))=0; % Threshold for number of fibers 
            
            for ii = 1:size(current_matAll,1)
                current_matAll(ii,ii,i)=0; % Ensure there are no self-connections
            end
            
            current_mat=current_matAll(:,:,i);
            
            % Prepare current_mat for the measures:
            % Local: clustering_coeff, betweenness and
            % Global: efficiency, transitivity, charPathLength           
            current_mat_NoNegatives = current_mat;
            current_mat_NoNegatives(current_mat<=0)=0; % Just in case        
            current_mat_NoNegatives_normalized = weight_conversion(current_mat_NoNegatives, 'normalize');
            
            % Reason: 
            % Some measures of the BCT only work with normalized data
            % (0-1) and one measure (betweenness) needs a connection length
            % matrix
            
            % The inverse matrix is some kind of connection length matrix.
            % High numbers of fibers result in short distances.
            
            current_mat_NoNegatives_inverse = 1./current_mat_NoNegatives;    
            
            % Local parameters for each region using graph theory (BCT)
            clustercoef(i,:) =  clustering_coef_wu(current_mat_NoNegatives_normalized);
            degrees(i,:) =      degrees_und(current_mat)';
            strengths(i,:)=     strengths_und(current_mat)';
            betweenness(i,:) =  betweenness_wei(current_mat_NoNegatives_inverse);
            centrality(i,:) =   eigenvector_centrality_und(current_mat);
            
            % Global parameters for each region using graph theory (BCT)
            density(i) = density_und(current_mat);
            transitivity(i) = transitivity_wu(current_mat_NoNegatives_normalized);
            assortativity(i) = assortativity_wei(current_mat,0);
            efficiency(i) = efficiency_wei(current_mat_NoNegatives_normalized);
            charPathLength(i) = 1./efficiency(i);  

            if sum(current_mat(:))==0
                modularity(i) = 0;
                disp(['The matrix of the study number ' tempName ' contains only zero values!'])
            else
                [~,modularity(i)] = modularity_und(current_mat,1);
            end
           
            % Get AD, FA0, RD and MD values and add them to the given struct
            adNii = load_nii(fullfile(adfile_cur(i).folder,adfile_cur(i).name));
            fa0Nii = load_nii(fullfile(fa0file_cur(i).folder,fa0file_cur(i).name));
            mdNii = load_nii(fullfile(mdfile_cur(i).folder,mdfile_cur(i).name));
            rdNii = load_nii(fullfile(rdfile_cur(i).folder,rdfile_cur(i).name));
            araNii = load_nii(fullfile(arafile_cur(i).folder,arafile_cur(i).name));
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
        infoDTI.degrees = degrees;
        infoDTI.strengths = strengths;
        infoDTI.betw_centrality = betweenness;
        infoDTI.eign_centrality = centrality;
        infoDTI.density = density;
        infoDTI.transitivity = transitivity;
        infoDTI.efficiency = efficiency;
        infoDTI.assortativity = assortativity;
        infoDTI.modularity = modularity;
        infoDTI.charPathLength = charPathLength;
        
        %If S>1 then the network can be labeled as "small world".
        infoDTI.smallWorldness= (nanmean(clustercoef(:,i),2)/charPathLength(i))';
        
        infoDTI.AD  = ad;
        infoDTI.FA0 = fa0;
        infoDTI.MD  = md;
        infoDTI.RD  = rd;
   
        targetPath = fullfile(out_path,groups(g));
        if ~exist(targetPath,'dir')
            mkdir(targetPath);
        end   
        disp(strcat(targetPath,filesep,days(d),'.mat'))
        disp(infoDTI.names)
        save(strcat(targetPath,filesep,days(d),'.mat'),'infoDTI')
    end
end




end