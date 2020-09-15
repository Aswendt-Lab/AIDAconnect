function plotLocalParameter(inputDTI, graphCell, strNodeName, strParameter)

%% plotLocalParameter
% Displays local graph properties of a region for two groups

% Input Arguments
% inputDTI and graphCell from mergeDTIdata_input.m
% strNodeName = Region to examine (as String)
% strParameter = 'Degree', 'Eigenvector', 'Betweenness', 
%                'Strength', 'FA0', 'AD', 'MD', 'RD'

%% Example
% plotLocalParameter(inputDTI, graphCell, 'L SSp-ul', 'Degree') 

%% Do not modify the following lines

days = inputDTI.days;
groups = inputDTI.groups;
numOfDays = size(inputDTI.days,2);
numOfGroups = size(inputDTI.groups,2);
tempFile = load('../Tools/infoData/acronyms_splitted.mat');
acronyms = tempFile.acronyms;
[~,b] = ismember(strNodeName,acronyms);

valuesGroup1 = nan(size(graphCell{1,1}.Nodes.allMatrix,3),numOfDays);
for dIdx=1:numOfDays
    numOfAnimals=size(graphCell{1,dIdx}.Nodes.allMatrix,3);
    for animal = 1:numOfAnimals
        switch lower(strParameter)
            case 'degree'
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.allDegree(b,animal);
            case 'strength'
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.allStrength(b,animal);
            case 'eigenvector'
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.allEigenvector(b,animal);
            case 'betweenness' 
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.allBetweenness(b,animal);
            case 'fa0'
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.FA0(b,animal);
            case 'ad'
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.AD(b,animal);
            case 'md'
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.MD(b,animal);
            case 'rd'
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.RD(b,animal);  
            otherwise
                error('No valid Argument')
        end
    end
end

valuesGroup1(valuesGroup1==0)=nan;
tableGroup1 = array2table(valuesGroup1);
for day = 1:numOfDays
    tableGroup1.Properties.VariableNames(day) = inputDTI.days(day);
end
disp(strcat(strParameter," of ",strNodeName," for all subjects in group ",inputDTI.groups(1),':'));
disp(tableGroup1);

valuesGroup2 = nan(size(graphCell{2,1}.Nodes.allMatrix,3),numOfDays);
for dIdx=1:numOfDays
    numOfAnimals=size(graphCell{2,dIdx}.Nodes.allMatrix,3);
   
    for animal = 1:numOfAnimals
         switch lower(strParameter)
            case 'degree'
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.allDegree(b,animal);
            case 'strength'
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.allStrength(b,animal); 
            case 'eigenvector'
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.allEigenvector(b,animal);
            case 'betweenness' 
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.allBetweenness(b,animal);
            case 'fa0'
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.FA0(b,animal);
            case 'ad'
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.AD(b,animal);
            case 'md'
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.MD(b,animal);
            case 'rd'
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.RD(b,animal);  
            otherwise
                error('No valid Argument')
         end
    end
end
valuesGroup2(valuesGroup2==0)=nan;
tableGroup2 = array2table(valuesGroup2);
for day = 1:numOfDays
    tableGroup2.Properties.VariableNames(day) = inputDTI.days(day);
end
disp(strcat(strParameter," of ",strNodeName," for all subjects in group ",inputDTI.groups(2),':'));
disp(tableGroup2);

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
title([strNodeName '-' strParameter])
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

