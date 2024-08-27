%% First Steps
% Consolidates all graph-theoretical measures of the processed rsfMRI-data. 
% Please specify all information below and hit 'Run'.

%% Specifications

% Path to the processed image data folder (e.g. proc_data)
inputFMRI.in_path = "C:\Users\aswen\Desktop\TestingData\Daniel\proc_data";

% Observation days e.g. “1","2" etc.
inputFMRI.days = ["1"];

% Groups e.g. “Sham” etc.
inputFMRI.groups =  ["test1", "test2"]; %Whatever you name your group in the GroupMapping.xlsx

% Threshold Type (0: Fixed, 1: Density-based)
thres_type = 1;

% Threshold (0-1)
% For the Density-based threshold, this is the proportion of
% the biggest weights to preserve
thres = 0.4;
 
% Output path 
inputFMRI.out_path = "C:\Users\aswen\Desktop\TestingData\Daniel\proc_data\funcOut";
acronymsFlag = "nonsplitted"  %Set here to "splited" or "nonsplitted" for the desired atlas to be used.

%% Do not modify the following lines
% This Script tests the existence of the output path and consolidates all
% data only if the path does not exist. If the path already exists only
% the struct inputFMRI and the cell matrices graphCell, matrixValues and ids
% will be created, which are necessary for several analysis functions.

addpath('../Tools/NIfTI/')
addpath('./rsfMRI_Processing/')
if ~exist(inputFMRI.out_path,'dir') || numel(dir(inputFMRI.out_path)) <= 2
    mkdir(inputFMRI.out_path)  
    getMergedFMRI_data(inputFMRI,thres_type,thres);
else
    f = msgbox("If you wish to process your data again, please delete the output folder manually.", "Attention");
end
[graphCell,matrixValues,ids]=graphAnalysis_fMRI(inputFMRI);

if acronymsFlag == "splitted"
acronyms = load('../Tools/infoData/acronyms_parental_splitted.mat').acronyms;
else
acronyms = load('../Tools/infoData/acronyms_parental.mat').acronyms;
end
