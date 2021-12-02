function plotGlobalParameter(inputFMRI, graphCell, strParameter)

%% plotGlobalParameter
% Displays global graph properties of the whole network for two groups

% Input Arguments
% inputFMRI and graphCell from mergeFMRIdata_input.m
% strParameter = 'Density', 'Transitivity', 'Efficiency', 'Assortativity', 
%                'Modularity', 'charPathLength', 'smallWorldness', 'overallconnectivity' 

%% Example
% plotGlobalParameter(inputFMRI, graphCell, 'Modularity') 

%% Do not modify the following lines

days = inputFMRI.days;
groups = inputFMRI.groups;
path = inputFMRI.out_path;
numOfDays = size(inputFMRI.days,2);
numOfGroups = size(inputFMRI.groups,2);
valuesGroup = cell(1,numOfGroups);
addpath('./rsfMRI_Processing/');

for gIdx=1:numOfGroups
    valuesGroup{gIdx} = nan(size(graphCell{gIdx,1}.Nodes.allMatrix,3),numOfDays);
    for dIdx=1:numOfDays
        switch lower(strParameter)
            case 'density'
                tempFile = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
                currValues = tempFile.infoFMRI.density;
                valuesGroup{gIdx}(1:size(currValues,2),dIdx) = currValues;
            case 'transitivity'
                tempFile = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
                currValues = tempFile.infoFMRI.transitivity;
                valuesGroup{gIdx}(1:size(currValues,2),dIdx) = currValues;
            case 'efficiency'
                tempFile = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
                currValues = tempFile.infoFMRI.efficiency;
                valuesGroup{gIdx}(1:size(currValues,2),dIdx) = currValues;
            case 'assortativity'
                tempFile = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
                currValues = tempFile.infoFMRI.assortativity;
                valuesGroup{gIdx}(1:size(currValues,2),dIdx) = currValues;
            case 'modularity'
                tempFile = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
                currValues = tempFile.infoFMRI.modularity;
                valuesGroup{gIdx}(1:size(currValues,2),dIdx) = currValues;
            case 'charpathlength'
                tempFile = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
                currValues = tempFile.infoFMRI.charPathLength;
                valuesGroup{gIdx}(1:size(currValues,2),dIdx) = currValues;
            case 'smallworldness'
                tempFile = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
                currValues = tempFile.infoFMRI.smallWorldness;
                valuesGroup{gIdx}(1:size(currValues,2),dIdx) = currValues;
            case 'overallconnectivity'
                tempFile = load(fullfile(path,groups(gIdx),[char(days(dIdx)) '.mat']));
                currValues = tempFile.infoFMRI.overallConnectivity;
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
    tableGroup1.Properties.VariableNames(day) = inputFMRI.days(day);
    tableGroup2.Properties.VariableNames(day) = inputFMRI.days(day);
end
disp(strcat(strParameter," of all subjects in group ",inputFMRI.groups(1),':'));
disp(tableGroup1);
disp(strcat(strParameter," of all subjects in group ",inputFMRI.groups(2),':'));
disp(tableGroup2);

plotFigure('plotGlobalParameter', days, groups, valuesGroup);
title(strParameter+" of all Groups")
ylabel(strParameter)