%% plotCorrelationMatrices
% This script displays scatter plots of the correlation of selected
% regions (figure 1) and their mean values and standard deviation (figure
% 2). Please adjust the parameters in lines 8 - 10 and hit 'Run'.

%% Specifications

filename =  "C:\Users\marc\Documents\UniklinikArbeit\Projekt_AIDAconnect\AIDAconnect_output_fmri\Treatment\Baseline.mat"; % path to a processed MAT-File

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

listWithSubjectIndices = zeros(1,numberOfSubjects);
for jj = 1:numberOfSubjects
    listWithSubjectIndices(jj) = jj; % (e.g. = [1,2,3,4,5])
end

% calculate mean values of group
mean_matrix = mean(infoFMRI.raw_matrix(:, :, listWithSubjectIndices), 3);

% determine min and max value
minval = round(min(min(mean_matrix)),1);
maxval = round(max(max(mean_matrix)),1);
clims = [minval-0.1, maxval+0.1]; % dynamic range of plot, e.g.: [0, 1] -> correlations between 0 and 1 can be displayed with different colors

% determine threshold type
thres = infoFMRI.thres;
thres_type = infoFMRI.thres_type;

if thres_type == 0
    thres_type_str = "fixed threshold";
elseif thres_type == 1
    thres_type_str = "proportional threshold";
else
    thres_type_str = "invalid threshold";
end

figure('Name', 'Mean Correlation Matrix and STD')
subplot(1,4,1)
imagesc(mean_matrix(:, :), clims);
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
imagesc(std(infoFMRI.raw_matrix(:, :, listWithSubjectIndices), 0, 3), clims./2);
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
binarized_matrix = mean_matrix;
[rows, cols, depth] = size(mean_matrix);
for ii=1:depth
    for jj=1:rows
        for hh=1:cols
            if mean_matrix(jj,hh,ii) < thres
                binarized_matrix(jj,hh,ii) = minval;
            else 
                binarized_matrix(jj,hh,ii) = maxval;
            end
        end
    end
end

subplot(1,4,3)
imagesc(mean(infoFMRI.matrix(:, :, listWithSubjectIndices), 3), clims);
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
title("w > " + thres + " " + thres_type_str + " binarized")
