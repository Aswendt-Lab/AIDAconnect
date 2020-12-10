function analyzeMostConnected(inputFMRI, graphCell, RegionPF, day, out_path)

%% analyzeMostConnected
% This function finds the most connected regions of a seed region per group for a
% selected time point. Please enter the seed region without specification
% of the hemisphere (L-, R-). The plot will automatically display both sides.
% You can save the table as a csv-file and the figure as a pdf-file 
% if you specify an output path as the last input argument 
% (see Specifications).

%% Specifications
NRegions2analyze = 7; % Finds the N most connected regions
displayOptions = 0; 
% displayOptions = 1 -> Displays the node sizes regarding the node strength
%                  and the connections regarding the connection weight
% displayOptions = 0 -> Displays the nodes and connections without differences in size
exportTable = 1;
exportFigure = 0;
% exportTable/Figure: Enter a 1 to export the table and/or figure. 
% Do not forget to specify an output path in this case.
%% Examples
% analyzeMostConnected(inputFMRI, graphCell, "SSs", "P28", "/Users/Username/Desktop/Files")
% analyzeMostConnected(inputFMRI, graphCell, "SSs", "P28")
% Remember to replace the path with an existing path or to just leave it out

%% Do not modify the following lines

if nargin == 4
    inputFMRI.save = 0;
    out_path = "";
else
    inputFMRI.save = 1; % control if figure/table should be saved
    if ~exist(out_path, 'dir')
        mkdir(out_path)
    end
end

% Day of observation
inputFMRI.days = [day]; 

% Add path to use getTotalData.m
addpath('./rsfMRI_Processing/')

% Load acronyms
load('../Tools/infoData/acronyms_splitted.mat');

Sides = ["L ","R "]; % Sides of Region-suffix to analyze
dIdx = find(contains(inputFMRI.days,day));
relevantRegionsID = [];
OverallRegionsIDs = NaN * ones(NRegions2analyze, 2);
relevantRegionsGrouped = NaN * ones(NRegions2analyze, 4);
sortedConnWeightsGrouped = NaN * ones(NRegions2analyze, 4);
inputFMRI.index=1:98;
[OutStruct] = getTotalData(inputFMRI);

for jj = 1:2 % Left and Right
    Region = strcat(Sides(jj), RegionPF);
    RegID = find(acronyms == Region);
    for ii = 1:2 % Group Number
        averageConnection = nanmean(squeeze(OutStruct.Data(RegID, :, :, 1, ii)), 2);
        [SortedConnWeights, idxSort] = sort(averageConnection);
        relevantRegionsID(:, ii) = idxSort(end-NRegions2analyze+1:end); 
        SortedConnWeights = SortedConnWeights(end-NRegions2analyze+1:end);
        relevantRegionsGrouped(:, jj+ii*2-2) = relevantRegionsID(:, ii);
        sortedConnWeightsGrouped(:, jj+ii*2-2) = SortedConnWeights;
    end
end

% Display the Table with the Regions and the Connection Weights
relevantRegionsGrouped = flip(acronyms(relevantRegionsGrouped(:,:)));
%disp(relevantRegionsGrouped);
sortedConnWeightsGrouped = flip(round(sortedConnWeightsGrouped,3));
groupTable = table(relevantRegionsGrouped(:,1),...
    sortedConnWeightsGrouped(:,1), relevantRegionsGrouped(:,2),...
    sortedConnWeightsGrouped(:,2), relevantRegionsGrouped(:,3),...
    sortedConnWeightsGrouped(:,3), relevantRegionsGrouped(:,4),...
    sortedConnWeightsGrouped(:,4));
groupTable.Properties.VariableNames = {...
    strcat(char(inputFMRI.groups(1)),' Left'),'W1',...
    strcat(char(inputFMRI.groups(1)),' Right'),'W2',...
    strcat(char(inputFMRI.groups(2)),' Left'),'W3',...
    strcat(char(inputFMRI.groups(2)),' Right'),'W4'};
display(groupTable);

disp('Figure 1 represents (Group 1): '+string(inputFMRI.groups(1)));
disp('Figure 2 represents (Group 2): '+string(inputFMRI.groups(2)));

% Create the Plot
% relevantRegionsGrouped contains the most connected regions for two groups
% and both hemispheres (without seed node)
% plotRelevantRegions contains the most connected regions and the seed node
% subGraphCell contains 4 cells with a subnetwork consisting of the
% seed node and the most connected regions for both groups left and right

plotRelevantRegions = relevantRegionsGrouped;
plotRelevantRegions(NRegions2analyze+1,1) = strcat("L ", RegionPF);
plotRelevantRegions(NRegions2analyze+1,2) = strcat("R ", RegionPF);
plotRelevantRegions(NRegions2analyze+1,3) = strcat("L ", RegionPF);
plotRelevantRegions(NRegions2analyze+1,4) = strcat("R ", RegionPF);

subGraphCell{1}=subgraph(graphCell{1,dIdx},cellstr(plotRelevantRegions(:,1)));
subGraphCell{2}=subgraph(graphCell{1,dIdx},cellstr(plotRelevantRegions(:,2)));
subGraphCell{3}=subgraph(graphCell{2,dIdx},cellstr(plotRelevantRegions(:,3)));
subGraphCell{4}=subgraph(graphCell{2,dIdx},cellstr(plotRelevantRegions(:,4)));

% Remove all Edges except from the Seed Node
for l = 1:4 % for all 4 plots (2 Groups + L/R)
    for k = 1:NRegions2analyze % from all Start Nodes
        for m = 1:NRegions2analyze % to all End Nodes
            subGraphCell{l} = rmedge(subGraphCell{l},relevantRegionsGrouped(k,l),relevantRegionsGrouped(m,l));
        end
    end
end

% Title of the plots
titStr(1) = strcat("L-",RegionPF);
titStr(2) = strcat("R-",RegionPF);

% Find axis values
minXCoord = zeros(1,4);
maxXCoord = zeros(1,4);
minYCoord = zeros(1,4);
maxYCoord = zeros(1,4);
for h = 1:4
    minXCoord(h) = min(subGraphCell{h}.Nodes.XCoord);
    maxXCoord(h) = max(subGraphCell{h}.Nodes.XCoord);
    minYCoord(h) = max(subGraphCell{h}.Nodes.YCoord);
    maxYCoord(h) = min(subGraphCell{h}.Nodes.YCoord);    
end
minXCoord = min(minXCoord); % Over all Plots
maxXCoord = max(maxXCoord);
minYCoord = max(minYCoord);
maxYCoord = min(maxYCoord);

% Figure Group 1
h1 = figure('Name', inputFMRI.groups(1));
set(gcf,'color','w');
for i = 1:2
    subplot(1,2,i)
    if displayOptions == 1
        LWidths = 3*subGraphCell{i}.Edges.Weight/max(subGraphCell{i}.Edges.Weight);
    else
        LWidths = 3;
    end
    p_R = plot(subGraphCell{i},'XData',subGraphCell{i}.Nodes.XCoord,...
        'YData',-subGraphCell{i}.Nodes.YCoord,'MarkerSize',15,...
        'LineWidth',LWidths,...
        'EdgeColor', '#696969');
    subGraphCell{i}.Nodes.allStrength(subGraphCell{i}.Nodes.allStrength==0)=1; % Because MarkerSize can't be 0
    if displayOptions == 1
        p_R.MarkerSize = 15*mean(subGraphCell{i}.Nodes.allStrength,2)/mean(max(subGraphCell{i}.Nodes.allStrength));
    else
        p_R.MarkerSize = 15;
    end
    title(titStr(i)+" at "+day,'FontSize', 18);
    hold on
    axis off
    axis([minXCoord maxXCoord -minYCoord -maxYCoord])
    nl = p_R.NodeLabel;
    p_R.NodeLabel='';
    xd = get(p_R, 'XData');
    yd = get(p_R, 'YData');
    zd = get(p_R, 'ZData');
    text(xd+10, yd, zd, nl, 'FontSize', 12);
end

% Figure Group 2
h2 = figure('Name', inputFMRI.groups(2));
set(gcf,'color','w');
for i = 1:2
    subplot(1,2,i)
    if displayOptions == 1
        LWidths = 3*subGraphCell{2+i}.Edges.Weight/max(subGraphCell{2+i}.Edges.Weight);
    else
        LWidths = 3;
    end
    p_R = plot(subGraphCell{2+i},'XData',subGraphCell{2+i}.Nodes.XCoord,...
        'YData',-subGraphCell{2+i}.Nodes.YCoord,'MarkerSize',15,...
        'LineWidth',LWidths,...
        'EdgeColor', '#696969');
    subGraphCell{2+i}.Nodes.allStrength(subGraphCell{2+i}.Nodes.allStrength==0)=1;
    if displayOptions == 1
        p_R.MarkerSize = 15*mean(subGraphCell{2+i}.Nodes.allStrength,2)/mean(max(subGraphCell{2+i}.Nodes.allStrength));
    else
        p_R.MarkerSize = 15;
    end
    title(titStr(i)+" at "+day,'FontSize', 18);
    hold on
    axis off
    axis([minXCoord maxXCoord -minYCoord -maxYCoord])
    nl = p_R.NodeLabel;
    p_R.NodeLabel='';
    xd = get(p_R, 'XData');
    yd = get(p_R, 'YData');
    zd = get(p_R, 'ZData');
    text(xd+10, yd, zd, nl, 'FontSize', 12);
end


if inputFMRI.save == 1
    if exportTable == 1
        writetable(groupTable,out_path+'/analyzeMostConnected.csv');
        disp('Table saved to '+out_path+'/analyzeMostConnected.csv');
    end
    if exportFigure == 1
        fig = h1;
        fig.PaperPositionMode = 'auto';
        print([out_path+'/'+inputFMRI.groups(1)+'_'+RegionPF+'_'+day], '-dpdf', '-fillpage')
        disp('Figure saved to '+out_path+'/'+inputFMRI.groups(1)+'_'+RegionPF+'_'+day+'.pdf');
        fig = h2;
        fig.PaperPositionMode = 'auto';
        print([out_path+'/'+inputFMRI.groups(2)+'_'+RegionPF+'_'+day], '-dpdf', '-fillpage')
        disp('Figure saved to '+out_path+'/'+inputFMRI.groups(2)+'_'+RegionPF+'_'+day+'.pdf');
    end
end
end

