%% plotCorrelationMatrices
% This script displays scatter plots of the correlation of selected
% regions (figure 1) and their mean values and standard deviation (figure
% 2). Please adjust the parameters in lines 8 - 10 and hit 'Run'.

%% Specifications

filename =  "/Users/Username/Documents/Projects/proc_data/outputFMRI/GroupName1/Baseline.mat"; % path to a processed MAT-File
selectedRegions = ["L SSp-ll", "L HIP", "R HIP", "L DORpm", "R DORpm", "L lfbst", "R DORsm"]; % defines regions to be shown (as in acronyms)
clims = [0, 0.6]; % dynamic range of plot, e.g.: [0, 1] -> correlations between 0 and 1 can be displayed with different colors

%% Do not modify the following lines

P = load(filename);
infoFMRI = P.infoFMRI;

load('../Tools/infoData/acronyms_splitted.mat');
numberOfSubjects = size(infoFMRI.names,1);

% Determine number of subplots
plotSize = sqrt(numberOfSubjects);
plotSize_compare = floor(plotSize)+0.5;
if plotSize < plotSize_compare
    plot_x = floor(plotSize);
    plot_y = ceil(plotSize);
else
    plot_x = ceil(plotSize);
    plot_y = plot_x;
end

% Convert regions to index number
for i = 1:size(selectedRegions,2)
    index(i) = find(strcmp(acronyms, selectedRegions(i)));
end

figure('Name', 'Correlation Matrix for each subject')
for ii = 1:numberOfSubjects
    subplot(plot_x, plot_y, ii);
    imagesc(infoFMRI.matrix(index, index, ii), clims)  
    axis square;
    set(gca, 'XTick', 1:length(index), ... % Change the axes tick marks
    'XTickLabel', acronyms(index), ...     % and tick labels
    'XTickLabelRotation', 90, ...
    'YTick', 1:length(index), ...
    'YTickLabel', acronyms(index), ...
    'TickLength', [0, 0]);
    title(strrep(infoFMRI.names{ii},'_',' '))
    c = colorbar;
    c.Label.String = "Correlation";
    caxis(clims)
end

listWithSubjectIndices = zeros(1,numberOfSubjects);
for jj = 1:numberOfSubjects
    listWithSubjectIndices(jj) = jj; % (e.g. = [1,2,3,4,5])
end

figure('Name', 'Mean Correlation Matrix and STD')
subplot(2, 1, 1)
imagesc(mean(infoFMRI.matrix(index, index, listWithSubjectIndices), 3), clims);
c = colorbar;
c.Label.String = "Correlation";
caxis(clims)
axis square;
set(gca, 'XTick', 1:length(index), ... % Change the axes tick marks
    'XTickLabel', acronyms(index), ... % and tick labels
    'XTickLabelRotation', 90, ...
    'YTick', 1:length(index), ...
    'YTickLabel', acronyms(index), ...
    'TickLength', [0, 0]);
title('Mean')

subplot(2, 1, 2)
imagesc(std(infoFMRI.matrix(index, index, listWithSubjectIndices), 0, 3), clims./2);
c = colorbar;
c.Label.String = "Correlation";
caxis(clims)
axis square;
set(gca, 'XTick', 1:length(index), ... % Change the axes tick marks
    'XTickLabel', acronyms(index), ... % and tick labels
    'XTickLabelRotation', 90, ...
    'YTick', 1:length(index), ...
    'YTickLabel', acronyms(index), ...
    'TickLength', [0, 0]);
title('Std')
