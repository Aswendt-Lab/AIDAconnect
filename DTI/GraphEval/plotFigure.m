function plotFigure(figName, days, groups, valuesGroup)

%% plotFigure
% This function is used by several functions and is not meant to be
% used manually. It takes a cell array valuesGroup as input
% which contains the parameter matrix of every group in each cell.
% The parameter matrix contains of rows (subjects) and columns (days).
% This function plots a figure which displays the parameter for all
% groups in a given time period.

numOfDays = size(days,2);
numOfGroups = size(groups,2);

% Determine number of subjects per group to make all datasets
% the same size to concatenate
if numOfGroups > 1
  sizePerValuesGroup=zeros(numOfGroups,1);
  for ii = 1:numOfGroups
    sizePerValuesGroup(ii)=size(valuesGroup{ii},1);
  end
  for jj = 1:numOfGroups
    valuesGroup{jj}(end+1:max(sizePerValuesGroup),:)=nan;
  end
  allData = horzcat(valuesGroup{:});
else
  allData = valuesGroup{1};
end
% Generate the figure
figure('Name', figName);
% Create equally distributed colors from the hsv color space
hsv_hue = flip(linspace(0,1,numOfGroups)*240/360);
hsv_saturation = 1;
hsv_value = 0.7;
hsv_colors = zeros(numOfGroups,3);
for v = 1:numOfGroups
  hsv_colors(v,1) = hsv_hue(v);
end
hsv_colors(:,2) = hsv_saturation;
hsv_colors(:,3) = hsv_value;
rgb_colors = hsv2rgb(hsv_colors);
% Display the boxplots (map the values to days/groups)
% Create right grouping data G for groups
G_Group=ones(numOfGroups*numOfDays,1);
for ii=1:numOfGroups
  G_Group(1+(ii-1)*numOfDays:(ii)*numOfDays)=ii;
end
if size(G_Group)==[1,1]
    boxplot(allData,{[repmat([1:numOfDays],1,numOfGroups)]},'color',rgb_colors,'FactorGap',15);
else
    boxplot(allData,{[repmat([1:numOfDays],1,numOfGroups)],G_Group},'color',rgb_colors,'FactorGap',15);
end
% Increase LineWidth of the boxplots
a = get(get(gca,'children'),'children');
t = get(a,'tag');
idx = strcmpi(t,'box');
boxes = a(idx);
set(boxes,'linewidth',2);
% Get the Xtick-Positions
if numOfDays > 1
  for d = numOfDays: -1:1
    for g = 1:numOfGroups
      meanXPerGroup(g) = mean(boxes(d*numOfGroups-numOfGroups+g).XData);
    end
  meanX = mean(meanXPerGroup);
  xtickPositions(numOfDays-d+1) = meanX;
  end
elseif numOfGroups==1
  xtickPositions = mean([boxes.XData(1) boxes.XData(3)]);
else
    for g = 1:numOfGroups
      meanXPerGroup(g) = mean(unique(boxes(g).XData));
    end
  meanX = mean(meanXPerGroup);
  xtickPositions(1) = meanX;
end
% Resize and recolor the median
idx_median = strcmpi(t,'median');
medianLines = a(idx_median);
set(medianLines,'color',[0,0,0]);
set(medianLines,'linewidth',2);
% Set whiskers to continuous lines
idx_lowerwhisker = strcmpi(t,'Lower Whisker');
lowerWhisker = a(idx_lowerwhisker);
set(lowerWhisker,'linestyle','-');
idx_upperwhisker = strcmpi(t,'Upper Whisker');
upperWhisker = a(idx_upperwhisker);
set(upperWhisker,'linestyle','-');
% Label the figure
xticks(xtickPositions);
set(gca, 'XTickLabel', [],'FontSize',12)
xticklabels(cellstr(days))
xlabel('Days')
strParameter = "Parameter";
ylabel(strParameter)
title(strParameter+" of all Groups")
grid on
grid minor
hold on
% Draw the curves
for ii=1:numOfGroups
  curveGroup{ii}=nanmedian(valuesGroup{ii});
end
if numOfDays > 1
  x = 1:numOfDays;
  xpk = 1:0.1:numOfDays;
  for ii=1:numOfGroups
    curveGroup_pchip{ii}=pchip(x,curveGroup{ii},xpk);
    plot(linspace(ii,meanXPerGroup(numOfGroups-ii+1),size(curveGroup_pchip{ii},2)),curveGroup_pchip{ii}(1:end),'Color',rgb_colors(ii,:),'LineWidth',1);
  end
else
  for ii=1:numOfGroups
    plot(curveGroup{ii},'Color',rgb_colors(ii,:));
  end
end
hold off
legend(strrep(groups,'_',' '))
%hLegend = legend(flipud(findall(gca,'Tag','Box')), strrep(groups,'_',' '));
%clear