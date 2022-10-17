function [graphCell,meanMatrixValues,ids,t,d,s]=graphAnalysis_fMRI(inputFMRI)

%% graphAnalysis
% This function is used by mergeFMRIdata_input.m and is not meant to be
% used manually.

path = inputFMRI.out_path;
groups = inputFMRI.groups;
days = inputFMRI.days;
%% Load related information
tempFile = load('..\Tools\infoData\acronyms_splitted.mat');
acronyms = tempFile.acronyms;
tempFile = load('..\Tools\infoData\acro_numbers_splitted.mat');
acro_numbers = tempFile.annotationsNumber;
niiData = load_nii('..\Tools\infoData\annoVolume+2000_rsfMRI.nii.gz');
volume = niiData.img;
%% Find center of gravity for existing labels
x_coord = nan(length(acro_numbers),1);
y_coord = nan(length(acro_numbers),1);
z_coord = nan(length(acro_numbers),1);
for i = 1:length(acro_numbers)
[r,c,v] = ind2sub(size(volume),find(volume == acro_numbers(i)));
x_coord(i) = ceil(mean(r));
y_coord(i) = ceil(mean(c));
z_coord(i) = ceil(mean(v));
end

%% Create graphs
meanMatrixValues = cell(length(groups),length(days));
ids = cell(length(groups),length(days));
graphCell = cell(length(groups),length(days));
for gIdx = 1:length(groups)
    disp('Load '+groups(gIdx))
    for dIdx = 1:length(days)    
        
        % Load the files created by getMergedFMRI_data.m 
        % and get the correlation matrices
        tempFile = load(fullfile(path,groups(gIdx), [char(days(dIdx)), '.mat']));
        tempMatrices = tempFile.infoFMRI.matrix;
        meanMatrixValues = mean(tempMatrices,3);
        ids{gIdx,dIdx} = tempFile.infoFMRI.names;

        disp(days(dIdx))
        
        % Build the graph using the upper triangle of the matrix stored
        % in meanMatrixValues
        G = graph(meanMatrixValues, cellstr(acronyms),'upper');
        G.Nodes.XCoord = x_coord;
        G.Nodes.YCoord = y_coord;
        G.Nodes.ZCoord = z_coord;
       
        % Store the matrices of all individual subjects in allMatrix   
        G.Nodes.allMatrix = tempMatrices;
        
        % Store local graph metrics at each node (region)
        for mIdx = 1:size(G.Nodes.allMatrix,3) % mIdx = animal Index    
            G.Nodes.allDegree(:,mIdx) = tempFile.infoFMRI.degrees(mIdx,:);
            G.Nodes.allStrength(:,mIdx) = tempFile.infoFMRI.strengths(mIdx,:);
            G.Nodes.allEigenvector(:,mIdx) = tempFile.infoFMRI.eign_centrality(mIdx,:);
            G.Nodes.allBetweenness(:,mIdx) = tempFile.infoFMRI.betw_centrality(mIdx,:);
            G.Nodes.allClustercoef(:,mIdx) = tempFile.infoFMRI.clustercoef(mIdx,:);
            G.Nodes.allParticipationcoef(:,mIdx) = tempFile.infoFMRI.participationcoef(mIdx,:);
            G.Nodes.allEfficiency(:,mIdx) = tempFile.infoFMRI.localEfficiency(mIdx,:);
        end
        graphCell{gIdx,dIdx} = G; 
    end
end


end





