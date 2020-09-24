function plotGlobalParameter(inputFMRI, graphCell, strParameter)

%% plotGlobalParameter
% Displays global graph properties of the whole network for two groups

% Input Arguments
% inputFMRI and graphCell from mergeFMRIdata_input.m
% strParameter = 'Density', 'Transitivity', 'Efficiency', 'Assortativity', 'Modularity', 'charPathLength', 'smallWorldness' 

%% Example
% plotGlobalParameter(inputFMRI, graphCell, 'Modularity') 

%% Do not modify the following lines

days = inputFMRI.days;
groups = inputFMRI.groups;
path = inputFMRI.out_path;
numOfDays = size(inputFMRI.days,2);
numOfGroups = size(inputFMRI.groups,2);
valuesGroup = cell(1,numOfGroups);

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

valuesGroup1 = valuesGroup{1}; 
valuesGroup2 = valuesGroup{2}; 
% currently, only two groups work. To be extended in future versions.

valuesGroup1(end+1:max(size(valuesGroup1,1),size(valuesGroup2,1)),:)=nan;
valuesGroup2(end+1:max(size(valuesGroup1,1),size(valuesGroup2,1)),:)=nan;
allData = [valuesGroup1,valuesGroup2];

% Generate the figure
h = figure;
% Display the boxplots (map the values to days/groups)
boxplot(allData,{[repmat([1:numOfDays],1,2)],[repmat(1,numOfDays,1);repmat(2,numOfDays,1)]},'color',repmat('br',1,12),'FactorGap',15);
% Increase LineWidth of the boxplots
a = get(get(gca,'children'),'children');  
t = get(a,'tag'); 
idx = strcmpi(t,'box');
boxes = a(idx);
set(boxes,'linewidth',2);
% Resize and recolor the median
idx_median = strcmpi(t,'median');
medianLines = a(idx_median);
set(medianLines,'color',[0,0,0]);
set(medianLines,'linewidth',2);
% Get the Xtick-Positions
for d = numOfDays:-1:1
    for g = 1:numOfGroups
        meanXPerGroup(g) = mean(boxes(d*numOfGroups-numOfGroups+g).XData);
    end
    meanX = mean(meanXPerGroup);
    xtickPositions(numOfDays-d+1) = meanX;
end
% Label the Figure
xticks(xtickPositions);
set(gca, 'XTickLabel', [],'FontSize',12)
xticklabels(cellstr(days))
xlabel('Days')
ylabel(strParameter)
title(strParameter+" of all Groups")
grid on
grid minor
hold on
% Draw the curves
curveGroup1 = nanmedian(valuesGroup1);
curveGroup2 = nanmedian(valuesGroup2);
if numOfDays > 1
    x = 1:numOfDays;
    xpk = 1:0.1:numOfDays;
    curveGroup1_pchip = pchip(x,curveGroup1,xpk);
    curveGroup2_pchip = pchip(x,curveGroup2,xpk);
    plot(linspace(1,meanXPerGroup(2),size(curveGroup1_pchip,2)),curveGroup1_pchip(1:end),'b','LineWidth',1);
    plot(linspace(2,meanXPerGroup(1),size(curveGroup2_pchip,2)),curveGroup2_pchip(1:end),'r','LineWidth',1);
else
    plot(curveGroup1);
    plot(curveGroup2);
end
hold off
legend(strrep(groups(1),'_',' '),strrep(groups(2),'_',' '));

