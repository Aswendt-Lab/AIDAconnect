%% User input

%% plotFiberCountMatrices
% This script displays the number of fibers of selected regions as scatter
% plots (figure 1) and their mean values and standard deviation (figure 2).
% Please adjust the parameters in lines 8 - 10 and hit 'Run'.

%% Specification

filename = "Y:\Desktop\Data\CRC_WP1\inputs\mri\proc_data\Results\AIDAconnect\OutputDTI_thres0_proc2"; % path to a processed MAT-File
files = dir(fullfile(filename,"**","*.mat"));

ROI_L = ["L MOp", "L MOs", "L SSp-ul","L SSp-ll", "L SSs"];
ROI_R = ["R MOp", "R MOs", "R SSp-ul","R SSp-ll", "R SSs"];
days = ["Baseline","P1","P7","P14","P21","P28"];
group = ["StrokeGood", "StrokeBad", "Sham"];
%% Do not modify the following lines
for gg = 1: size(group,2)
    for dd = 1:size(days,2)
        P = load(fullfile(filename,group(gg),days(dd))+".mat");
        infoDTI = P.infoDTI;

        load('..\Tools\infoData\acronyms_splitted.mat');
        numberOfSubjects = size(infoDTI.names,1);
        % Convert regions to index number
        for i = 1:size(ROI_L,2)
            indexL(i) = find(strcmp(acronyms, ROI_L(i)));
        end
        for i = 1:size(ROI_R,2)
            indexR(i) = find(strcmp(acronyms, ROI_R(i)));
        end


        %figure('Name', 'Fiber Count Matrix for each subject')
        for ii = 1:numberOfSubjects
            D = infoDTI.matrix(indexR, indexL, ii);
            D = D.*eye(size(D));
            temp = diag(D)';
            temp(temp == 0) = inf;
            %diagonal_d(ii,:,gg,dd) = temp;
            diagonal_d(dd,ii,gg,:) = temp;
        
        end

    end
end
temp = diagonal_d;
temp(temp == 0) = nan;
temp(temp == inf) = 0;
Final_Data = temp;
size(Final_Data)
disp("days,mice,groups,regions")
%%
for cc = 1:size(Final_Data,4)
Comparisons{cc} = [Final_Data(:,:,1,cc),Final_Data(:,:,2,cc),Final_Data(:,:,3,cc)]; 
end

%% Box plots
% Define the parameters for the plot
plotColors = ['r', 'g', 'b']; % colors for each group
boxWidth = 0.6; % width of the box
boxLineWidth = 1; % width of the box border
fontSize = 12; % font size of the labels and title
labelFontSize = 10; % font size of the axis labels
titleFontSize = 14; % font size of the plot title

% Loop over each region combination
for i = 1:size(ROI_L, 2)
    for j = 1:size(ROI_R, 2)
        
        % Create a new figure for each region combination
        figure('Name', [ROI_L{i} ' ' ROI_R{j}]);
        
        % Loop over each timepoint
        for k = 1:size(days, 2)
            
            % Get the data for each group
            data = [];
            for gg = 1:size(group, 2)
                data_g = Final_Data(k, :, gg, j, i);
                data = [data; data_g];
            end
            
            % Create a subplot for each timepoint
            subplot(2, 3, k);
            
            % Create the boxplot for each group
            boxplot(data, 'Colors', plotColors, 'Widths', boxWidth, 'Symbol', '+', 'Whisker', 1.5, 'LineWidth', boxLineWidth);
            
            % Set the axis labels and title
            xlabel('Group', 'FontSize', labelFontSize);
            ylabel('Fiber Count', 'FontSize', labelFontSize);
            title([days{k} ' - ' ROI_L{i} ' ' ROI_R{j}], 'FontSize', titleFontSize);
            set(gca, 'XTickLabel', group, 'FontSize', fontSize);
            
        end
        
        % Adjust the position of the subplots
        set(gcf, 'Position', get(0, 'Screensize'));
        
    end
end

