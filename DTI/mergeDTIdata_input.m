%% First Steps
% Consolidates all graph-theoretical measures of the processed DTI-data. 
% Please specify all information below and hit 'Run'.
 

%% Specifications

% Path to the processed image data folder (e.g. proc_data)
inputDTI.in_path = "E:\CRC_data\SND\proc_data";

inputDTI.days = ["Baseline", "P1", "P7", "P14","P21","P28"];
% Groups (e.g. "Sham" etc.)
inputDTI.groups = ["all"];

% Threshold Type (0: Fixed, 1: Density-based)
thres_type = 1;

% Threshold (0-1)
% For the Density-based threshold, this is the proportion of
% the biggest weights to preserve
thres = 0.7;

% Output path 
inputDTI.out_path = "E:\CRC_data\SND\outputConnect";
acronymsFlag = "splitted"  %Set here to "splited" or "nonsplitted" for the desired atlas to be used.

%% Do not modify the following lines
% This script tests the existence of the output path and consolidates all
% data only if the path does not exist. If the path already exists only
% the struct inputDTI and the cell matrices graphCell, matrixValues and ids
% will be created, which are necessary for several analysis functions.

addpath('../Tools/NIfTI/')
addpath('./GraphEval/')
if ~exist(inputDTI.out_path,'dir') || numel(dir(inputDTI.out_path)) <= 2
    mkdir(inputDTI.out_path)
    getMergedDTI_data(inputDTI,thres_type,thres);
else
    f = msgbox("If you wish to process your data again, please delete the output folder manually.", "Attention");
end
[graphCell,matrixValues,ids]=graphAnalysis_DTI(inputDTI);
if acronymsFlag == "splitted"
acronyms = load('../Tools/infoData/acronyms_parental_splitted.mat').acronyms;
else
acronyms = load('../Tools/infoData/acronyms_parental.mat').acronyms;
end
