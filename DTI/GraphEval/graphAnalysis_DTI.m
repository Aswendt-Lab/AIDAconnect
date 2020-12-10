function [graphCell,matrixValues,ids]=graphAnalysis_DTI(inputDTI)

%% graphAnalysis
% This function is used by mergeDTIdata_input.m and is not meant to be
% used manually.

path = inputDTI.out_path;
groups = inputDTI.groups;
days = inputDTI.days;
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
        
        tempV = mean(tempF.infoDTI.matrix,3);
        matrixValues{gIdx,dIdx} = tempV;
        matrixThres = abs(matrixValues{gIdx,dIdx});
        
        ids{gIdx,dIdx} = tempF.infoDTI.names;
        
        matrix = matrixValues{gIdx,dIdx};
        labels = tempF.infoDTI.labels;
        
        disp(days(dIdx))
        G = graph(matrixThres, cellstr(acronyms),'upper');
        G.Nodes.XCoord = x_coord;
        G.Nodes.YCoord = y_coord;
        G.Nodes.ZCoord = z_coord;
        
        tempMatrix = tempF.infoDTI.matrix;        
        G.Nodes.allMatrix = tempMatrix;
           
        for mIdx = 1:size(G.Nodes.allMatrix,3) % mIdx = animal Index
        % Calculations based on BCT  
            G.Nodes.allDegree(:,mIdx) = tempF.infoDTI.degrees(mIdx,:);
            G.Nodes.allStrength(:,mIdx) = tempF.infoDTI.strengths(mIdx,:);
            G.Nodes.allEigenvector(:,mIdx) = tempF.infoDTI.eign_centrality(mIdx,:);
            G.Nodes.allBetweenness(:,mIdx) = tempF.infoDTI.betw_centrality(mIdx,:); 
            G.Nodes.allClustercoef(:,mIdx) = tempF.infoDTI.clustercoef(mIdx,:);
            G.Nodes.allEfficiency(:,mIdx) = tempF.infoDTI.localEfficiency(mIdx,:);
            G.Nodes.FA0(:,mIdx) = tempF.infoDTI.FA0(mIdx,:);
            G.Nodes.AD(:,mIdx) = tempF.infoDTI.AD(mIdx,:);
            G.Nodes.MD(:,mIdx) = tempF.infoDTI.MD(mIdx,:);
            G.Nodes.RD(:,mIdx) = tempF.infoDTI.RD(mIdx,:);
        end
        graphCell{gIdx,dIdx} = G; 
    end
end

end





