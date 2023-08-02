%% plotCorrelationMatrices
% This script displays scatter plots of the correlation of selected
% regions (figure 1) and their mean values and standard deviation (figure
% 2). Please adjust the parameters in lines 8 - 10 and hit 'Run'.

%% Specifications

filename = "/Volumes/path/to/proc_data/Treatment/P28.mat"; % path to a processed MAT-File

%% Do not modify the following lines

P = load(filename);
infoDTI = P.infoDTI;

load('../Tools/infoData/acronyms_splitted.mat');


% calculate mean values of group
mean_matrix = nanmean(infoDTI.raw_matrix, 3);
std_matrix = nanstd(infoDTI.raw_matrix,0,3);

% Determine min and max values for visualization
minval = 0;
maxval = max(max(mean_matrix));
clims = [minval, maxval]; % dynamic range of plot, e.g.: [0, 1] -> correlations between 0 and 1 can be displayed with different colors

% Determine threshold type
thres = infoDTI.thres;
thres_type = infoDTI.thres_type;

% determine threshold type
if thres_type == 0
    thres_type_str = "fixed threshold";
    thresh_matrix = threshold_absolute(mean_matrix, thres);
elseif thres_type == 1
    thres_type_str = "density threshold";
    thresh_matrix = threshold_proportional(mean_matrix, thres);
else
    thres_type_str = "invalid threshold";
end

figure('Name', 'Visualization of full matrix')
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
binarized_matrix(binarized_matrix>0) = maxval;



subplot(1,4,3)
imagesc(thresh_matrix, clims);
c = colorbar;
c.Label.String = "Correlation";
caxis(clims)
axis square;
set(gca, 'XTick', [1,25,50,75,98], ... % Change the axes tick marks
    'XTickLabel', [1,25,50,75,98], ... % and tick labels
    'XTickLabelRotation', 90, ...
    'YTick', [1,25,50,75,98], ...
    'YTickLabel', [1,25,50,75,98]); 
title("w > " + thres + " " + thres_type_str)

if thres > 0
    subplot(1,4,4)
    imagesc(binarized_matrix, clims);
    c = colorbar;
    c.Label.String = "Correlation";
    caxis(clims)
    axis square;
    set(gca, 'XTick', [1,25,50,75,98], ... % Change the axes tick marks
        'XTickLabel', [1,25,50,75,98], ... % and tick labels
        'XTickLabelRotation', 90, ...
        'YTick', [1,25,50,75,98], ...
        'YTickLabel', [1,25,50,75,98]); 
    title_str = "w > " + thres + " " + thres_type_str + " binarized";
    title(title_str)
end
