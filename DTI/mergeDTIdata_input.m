%% First Steps
% Consolidates all graph-theoretical measures of the processed DTI-data. 
% Please specify all information below and hit 'Run'.

%% Specifications

% Path to the processed image data folder (e.g. proc_data)
inputDTI.in_path = "Z:\CRC_WP1\outputs\AIDAconnet_results\OutputDTI_thres0";

% Observation days (e.g. "P1" etc.)
inputDTI.days = ["Baseline","P1","P7","P14","P21","P28"]; 
%inputDTI.days = ["Baseline","P1","P7","P14","P21","P28"]; 

% Groups (e.g. "Sham" etc.)
inputDTI.groups = ["StrokeGood","Sham"];

% Threshold Type (0: Fixed, 1: Density-based)
thres_type = 0;

% Threshold (0-1)
% For the Density-based threshold, this is the proportion of
% the biggest weights to preserve
thres = 0;

% Output path 
inputDTI.out_path =  "Z:\CRC_WP1\outputs\AIDAconnet_results\OutputDTI_thres0";
%% Do not modify the following lines
% This script tests the existence of the output path and consolidates all
% data only if the path does not exist. If the path already exists only
% the struct inputDTI and the cell matrices graphCell, matrixValues and ids
% will be created, which are necessary for several analysis functions.
if ~exist(inputDTI.out_path,'dir')
    mkdir(inputDTI.out_path)
    getMergedDTI_data(inputDTI,thres_type,thres);
end

[graphCell,matrixValues,ids]=graphAnalysis_DTI(inputDTI);
acronyms = load('..\Tools\infoData\acronyms_splitted.mat').acronyms;
