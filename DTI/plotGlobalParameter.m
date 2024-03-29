function plotGlobalParameter(inputDTI, graphCell, strParameter)

%% plotGlobalParameter
% Displays global graph properties of the whole network for two groups

% Input Arguments
% inputDTI and graphCell from mergeDTIdata_input.m
% strParameter = 'Density', 'Transitivity', 'Efficiency', 'Assortativity', 
%                'Modularity', 'charPathLength', 'smallWorldness', 'overallconnectivity' 

%% Example
% plotGlobalParameter(inputDTI, graphCell, 'Density') 

%% Do not modify the following lines

days = inputDTI.days;
groups = inputDTI.groups;
path = inputDTI.out_path;
numOfDays = size(days,2);
numOfGroups = size(groups,2);
valuesGroup = cell(1,numOfGroups);
addpath('./GraphEval/');

for gIdx=1:numOfGroups
    valuesGroup{gIdx} = nan(size(graphCell{gIdx,1}.Nodes.allMatrix,3),numOfDays);
    for dIdx=1:numOfDays
        switch lower(strParameter)
            case 'density'
                tempFile = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
                currValues = tempFile.infoDTI.density;
                valuesGroup{gIdx}(1:size(currValues,2),dIdx) = currValues;
            case 'transitivity'
                tempFile = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
                currValues = tempFile.infoDTI.transitivity;
                valuesGroup{gIdx}(1:size(currValues,2),dIdx) = currValues;
            case 'efficiency'
                tempFile = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
                currValues = tempFile.infoDTI.efficiency;
                valuesGroup{gIdx}(1:size(currValues,2),dIdx) = currValues;
            case 'assortativity'
                tempFile = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
                currValues = tempFile.infoDTI.assortativity;
                valuesGroup{gIdx}(1:size(currValues,2),dIdx) = currValues;
            case 'modularity'
                tempFile = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
                currValues = tempFile.infoDTI.modularity;
                valuesGroup{gIdx}(1:size(currValues,2),dIdx) = currValues;
            case 'charpathlength'
                tempFile = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
                currValues = tempFile.infoDTI.charPathLength;
                valuesGroup{gIdx}(1:size(currValues,2),dIdx) = currValues;
            case 'smallworldness'
                tempFile = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
                currValues = tempFile.infoDTI.smallWorldness;
                valuesGroup{gIdx}(1:size(currValues,2),dIdx) = currValues;
            case 'overallconnectivity'
                tempFile = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
                currValues = tempFile.infoDTI.overallConnectivity;
                valuesGroup{gIdx}(1:size(currValues,2),dIdx) = currValues;
            otherwise
                error('No valid Argument')
        end
    end
end

for gIdx=1:numOfGroups
    valuesGroup{gIdx}(valuesGroup{gIdx}==0)=nan;
end

tableGroup1 = array2table(valuesGroup{1});
tableGroup2 = array2table(valuesGroup{2});

for day = 1:numOfDays
    tableGroup1.Properties.VariableNames(day) = inputDTI.days(day);
    tableGroup2.Properties.VariableNames(day) = inputDTI.days(day);
end
disp(strcat(strParameter," of all subjects in group ",inputDTI.groups(1),':'));
disp(tableGroup1);
disp(strcat(strParameter," of all subjects in group ",inputDTI.groups(2),':'));
disp(tableGroup2);

plotFigure('plotGlobalParameter', days, groups, valuesGroup);
title(strParameter+" of all Groups")
ylabel(strParameter)
