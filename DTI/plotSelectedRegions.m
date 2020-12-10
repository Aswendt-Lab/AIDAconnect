function plotSelectedRegions(inputDTI, graphCell)

%% plotSelectedRegions
% This function plots selected regions in anatomically correct positions
% for all days in inputDTI. The color of the regions represents either 
% the Node Degree or the Node Strength (see options).
% Please specify the regions and options down below, save and enter
% the command line in the command window (see Example).

% selected regions
selectedRegions = ["L SSp-un", "L SSs", "L SSp-ll", "L DORpm", "R DORpm"];

% options values: 'degree' or 'strength'
options = 'degree';
displayOptions = 1;
% displayOptions = 1 -> Displays the node sizes regarding the node strength
%                  and the connections regarding the connection weight
% displayOptions = 0 -> Displays the nodes and connections without differences in size

%% Example
% plotSelectedRegions(inputDTI, graphCell)

%% Do not modify the following lines
% Generate graph plot for the selected regions and determine limit values

addpath(genpath('./GraphEval'))

minDegreeAll = zeros(length(inputDTI.groups),length(inputDTI.days));
maxDegreeAll = minDegreeAll;
minWeightAll = minDegreeAll;
maxWeightAll = minDegreeAll;
minStrengthAll = minDegreeAll;
maxStrengthAll = minDegreeAll;
allLimits = cell(1,3);

for i=1:length(inputDTI.groups)
    subgraphCell=cell(1,length(inputDTI.days));
    for j=1:length(inputDTI.days)       
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
        maxDegreeAll(i,j) = mean(max(subgraphCell{j}.Nodes.allDegree)); % Max for all regions, avg for all subjects
        minWeightAll(i,j) = min(subgraphCell{j}.Edges.Weight);
        maxWeightAll(i,j) = max(subgraphCell{j}.Edges.Weight);
        maxStrengthAll(i,j) = mean(max(subgraphCell{j}.Nodes.allStrength)); % Max for all regions, avg for all subjects
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

for i=1:length(inputDTI.groups)
    figure('Name', inputDTI.groups(i));
    disp('Figure '+string(i)+' represents: '+string(inputDTI.groups(i)))
    set(gcf,'color','w');
    plotNodes(subgraphCellperGroup{i},inputDTI.days,allLimits,options,displayOptions)
    hold off
end
    

