function [graphCell,matrixValues,ids,t,d,s]=graphAnalysis_fMRI(inputFMRI)

%% graphAnalysis
% This function is used by mergeFMRIdata_input.m and is not meant to be
% used manually.

path = inputFMRI.out_path;
groups = inputFMRI.groups;
days = inputFMRI.days;
%% load related information
tempFile = load('../Tools/infoData/acronyms_splitted.mat');
acronyms = tempFile.acronyms;
tempFile = load('../Tools/infoData/acro_numbers_splitted.mat');
acro_numbers = tempFile.annotationsNumber;
niiData = load_nii('../Tools/infoData/annoVolume+2000_rsfMRI.nii.gz');
volume = niiData.img;
%% find center of gravity for existing labels
x_coord = nan(length(acro_numbers),1);
y_coord = nan(length(acro_numbers),1);
z_coord = nan(length(acro_numbers),1);
for i = 1:length(acro_numbers)
[r,c,v] = ind2sub(size(volume),find(volume == acro_numbers(i)));
x_coord(i) = ceil(mean(r));
y_coord(i) = ceil(mean(c));
z_coord(i) = ceil(mean(v));
end

%% create graphs
matrixValues = cell(length(groups),length(days));
ids = cell(length(groups),length(days));
graphCell = cell(length(groups),length(days));
for gIdx = 1:length(groups)
    for dIdx = 1:length(days)
        
        tempF = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
        
        tempV = mean(tempF.infoFMRI.matrix,3);
        matrixValues{gIdx,dIdx} = tempV;
        matrixThres = abs(matrixValues{gIdx,dIdx});      
        ids{gIdx,dIdx} = tempF.infoFMRI.names;
        
        matrix = matrixValues{gIdx,dIdx};
        labels = tempF.infoFMRI.labels;
        
        disp(days(dIdx))
        G = graph(matrixThres, cellstr(acronyms),'upper');
        G.Nodes.XCoord = x_coord;
        G.Nodes.YCoord = y_coord;
        G.Nodes.ZCoord = z_coord;
        
        tempMatrix = tempF.infoFMRI.matrix;    
        G.Nodes.allMatrix = tempMatrix;

        for mIdx = 1:size(G.Nodes.allMatrix,3) % mIdx = animal Index
        % calculations based on BCT     
            G.Nodes.allDegree(:,mIdx) = tempF.infoFMRI.degrees(mIdx,:);
            G.Nodes.allStrength(:,mIdx) = tempF.infoFMRI.strengths(mIdx,:);
            G.Nodes.allEigenvector(:,mIdx) = tempF.infoFMRI.eign_centrality(mIdx,:);
            G.Nodes.allBetweenness(:,mIdx) = tempF.infoFMRI.betw_centrality(mIdx,:);
            G.Nodes.allClustercoef(:,mIdx) = tempF.infoFMRI.clustercoef(mIdx,:);
            G.Nodes.allEfficiency(:,mIdx) = tempF.infoFMRI.localEfficiency(mIdx,:);
        end
        graphCell{gIdx,dIdx} = G; 
    end
end


end





