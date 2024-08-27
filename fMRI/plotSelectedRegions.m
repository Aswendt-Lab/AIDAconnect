function plotSelectedRegions(inputFMRI, graphCell)

%% plotSelectedRegions
% This function plots selected regions in anatomically correct positions
% for all days in inputFMRI. The color of the regions represents either 
% the Node Degree or the Node Strength (see options).
% Please specify the regions and options down below, save and enter
% the command line in the command window (see Example).

% selected regions
selectedRegions=["L_PSC_BF","R_PSC_BF"];

% options values: 'degree' or 'strength'
options='degree';
displayOptions = 0;
% displayOptions = 1 -> Displays the node sizes regarding the node strength
%                  and the connections regarding the connection weight
% displayOptions = 0 -> Displays the nodes and connections without differences in size

%% Example
% plotSelectedRegions(inputFMRI, graphCell)

%% Do not modify the following lines
% Generate graph plot for the selected regions and determine limit values

addpath(genpath('./rsfMRI_Processing'))

minDegreeAll = zeros(length(inputFMRI.groups),length(inputFMRI.days));
maxDegreeAll = minDegreeAll;
minWeightAll = minDegreeAll;
maxWeightAll = minDegreeAll;
minStrengthAll = minDegreeAll;
maxStrengthAll = minDegreeAll;
allLimits = cell(1,3);

for i=1:length(inputFMRI.groups)
    subgraphCell=cell(1,length(inputFMRI.days));
    for j=1:length(inputFMRI.days)       
        subgraphCell{j}=subgraph(graphCell{i,j},cellstr(selectedRegions));
        
        degreeMatrix = subgraphCell{j}.Nodes.allDegree;
        strengthMatrix = subgraphCell{j}.Nodes.allStrength;
        
        for k=1:size(degreeMatrix,2)
            degreeCurrentColumn = degreeMatrix(:,k);
            strengthCurrentColumn = strengthMatrix(:,k);
            minDegreeAllSubjects(k) = min(degreeCurrentColumn(degreeCurrentColumn>0));
            minStrengthAllSubjects(k) = min(strengthCurrentColumn(strengthCurrentColumn>0));          
        end
        AvgMinDegree = mean(minDegreeAllSubjects);
        AvgMinStrength = mean(minStrengthAllSubjects);
        minDegreeAll(i,j) = AvgMinDegree;
        minStrengthAll(i,j) = AvgMinStrength;
        
        maxDegreeAll(i,j) = mean(max(subgraphCell{j}.Nodes.allDegree)); % Max for all regions, mean for all subjects
        minWeightAll(i,j) = min(subgraphCell{j}.Edges.Weight);
        maxWeightAll(i,j) = max(subgraphCell{j}.Edges.Weight);
        maxStrengthAll(i,j) = mean(max(subgraphCell{j}.Nodes.allStrength)); % Max for all regions, mean for all subjects
    end
    subgraphCellperGroup{i} = subgraphCell;
end

minDegree = min(minDegreeAll(:)); % Over all days regarding both groups
maxDegree = max(maxDegreeAll(:));
degreeLimits=[minDegree maxDegree];
minWeight = min(minWeightAll(:));
maxWeight = max(maxWeightAll(:));
weightLimits = [minWeight maxWeight];
minStrength = min(minStrengthAll(:));
maxStrength = max(maxStrengthAll(:));
strengthLimits = [minStrength maxStrength];

allLimits{1} = degreeLimits;
allLimits{2} = weightLimits;
allLimits{3} = strengthLimits;

for i=1:length(inputFMRI.groups)
    figure('Name', inputFMRI.groups(i));
    disp('Figure '+string(i)+' represents: '+string(inputFMRI.groups(i)))
    set(gcf,'color','w');
    plotNodes(subgraphCellperGroup{i},inputFMRI.days,allLimits,options,displayOptions)
    hold off
end
    

