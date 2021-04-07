function plotSignificantMatrix(inputFMRI, day, out_path)

%% plotSignificantMatrix
% This function tests all connections in the connectivity matrices within
% inputFMRI. No correction applied. All connections with p-Value<0.05 
% are displayed as a 1 in the plot. You can save the plot as significantConn.pdf 
% if you specify an output path as the third input argument.

% Input Arguments
% inputFMRI from mergeFMRIdata_input.m
% day = Name of the day as in inputFMRI.days (as String)
% out_path = Output path of the plot (as String)


%% Examples
% plotSignificantMatrix(inputFMRI, "P28", "/Users/Username/Desktop")
% plotSignificantMatrix(inputFMRI, "P28")
% Remember to replace the path with an existing path or to just leave it out

%% Do not modify the following lines

% Control if figure should be saved
if nargin == 2 
    inputFMRI.save = 0;
    out_path = "";
else
    inputFMRI.save = 1;
    if ~exist(out_path, 'dir')
    mkdir(out_path)
    end
end 

% Generate matrix of significant connections
addpath('./rsfMRI_Processing/')
acronyms = load('../Tools/infoData/acronyms_splitted.mat').acronyms;
numOfRegions = size(acronyms,1);
inputFMRI.index = 1:numOfRegions;
[OutStruct] = getTotalData(inputFMRI);
p = [];
dayI = find(inputFMRI.days == day);
for ii = 1:size(OutStruct.Data, 1)
    for jj = 1:size(OutStruct.Data, 2)
        [p(ii, jj), ~, ~] = anova1(squeeze(OutStruct.Data(ii, jj, :, dayI, :)), 1:1:2, 'off');
    end
end
figure()
imagesc(p < 0.05)
title(['Significant Group Differences Day ', char(inputFMRI.days(dayI))])
ylabel('Regions of Group 1: '+strrep(inputFMRI.groups(1),'_',' '));
xlabel('Regions of Group 2: '+strrep(inputFMRI.groups(2),'_',' '));
set(gca,'xtick',1:numOfRegions,'xticklabel',acronyms,'fontsize',8)
set(gca,'ytick',1:numOfRegions,'yticklabel',acronyms,'fontsize',8)
xtickangle(45);

if inputFMRI.save == 1
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([char(out_path), '/significantConn'], '-dpdf', '-fillpage');
    disp('Figure saved to '+out_path+'/significantConn.pdf');
end

