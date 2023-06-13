%% plotCorrelationMatrices
% This script displays scatter plots of the correlation of selected
% regions (figure 1) and their mean values and standard deviation (figure
% 2). Please adjust the parameters in lines 8 - 10 and hit 'Run'.

%% Specifications

filename =  "/Volumes/path/to/proc_data/Treatment/P28.mat"; % path to a processed MAT-File
% select data to plot, 1 for r-values and 0 for z-values 
dtype = 0;

%% Do not modify the following lines

P = load(filename);
infoFMRI = P.infoFMRI;

if dtype == 1
    data = infoFMRI.pcorrR_matrix;
else
    data = infoFMRI.pcorrZ_matrix;
end

load('../Tools/infoData/acronyms_splitted.mat');


% calculate mean values of group
mean_matrix = nanmean(data, 3);
std_matrix = nanstd(data,0, 3);

% determine min and max value
minval = round(min(min(mean_matrix)),1);
maxval = round(max(max(mean_matrix)),1);
clims = [-1, 1]; % dynamic range of plot, e.g.: [0, 1] -> correlations between 0 and 1 can be displayed with different colors

% determine threshold type
thres = infoFMRI.thres;
thres_type = infoFMRI.thres_type;

if thres_type == 0
    thres_type_str = "fixed threshold";
    thresh_matrix = threshold_absolute(mean_matrix,infoFMRI.thres);
elseif thres_type == 1
    thres_type_str = "density threshold";
    thresh_matrix = threshold_proportional(mean_matrix,infoFMRI.thres);
else
    thres_type_str = "invalid threshold";
end

figure('Name', 'Mean Correlation Matrix and STD')
subplot(1,4,1)
imagesc(mean_matrix, clims);
c = colorbar;
c.Label.String = "Correlation";
caxis(clims)
axis square;
set(gca, 'XTick', [1,25,50,75,98], ... % Change the axes tick marks
    'XTickLabel', [1,25,50,75,98], ... % and tick labels
    'XTickLabelRotation', 90, ...
    'YTick', [1,25,50,75,98], ...
    'YTickLabel', [1,25,50,75,98]); 
title('Mean')

test = std(mean_matrix,0);
subplot(1,4,2)
imagesc(std_matrix, clims./2);
c = colorbar;
c.Label.String = "Correlation";
caxis(clims)
axis square;
set(gca, 'XTick', [1,25,50,75,98], ... % Change the axes tick marks
    'XTickLabel', [1,25,50,75,98], ... % and tick labels
    'XTickLabelRotation', 90, ...
    'YTick', [1,25,50,75,98], ...
    'YTickLabel', [1,25,50,75,98]); 
title('Std')

% binarize matrix
binarized_matrix = thresh_matrix;
binarized_matrix(binarized_matrix>0) = 1;


subplot(1,4,3)
imagesc(thresh_matrix, clims);
c = colorbar;
c.Label.String = "Correlation";
caxis([0 1])
axis square;
set(gca, 'XTick', [1,25,50,75,98], ... % Change the axes tick marks
    'XTickLabel', [1,25,50,75,98], ... % and tick labels
    'XTickLabelRotation', 90, ...
    'YTick', [1,25,50,75,98], ...
    'YTickLabel', [1,25,50,75,98]); 
title("w > " + thres + " " + thres_type_str)

subplot(1,4,4)
imagesc(binarized_matrix, clims);
c = colorbar;
c.Label.String = "Correlation";
caxis([0 1])
axis square;
set(gca, 'XTick', [1,25,50,75,98], ... % Change the axes tick marks
    'XTickLabel', [1,25,50,75,98], ... % and tick labels
    'XTickLabelRotation', 90, ...
    'YTick', [1,25,50,75,98], ...
    'YTickLabel', [1,25,50,75,98]); 
title("w > " + thres + " " + thres_type_str + " binarized")
