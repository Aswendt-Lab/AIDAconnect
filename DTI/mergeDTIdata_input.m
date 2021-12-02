%% First Steps
% Consolidates all graph-theoretical measures of the processed DTI-data. 
% Please specify all information below and hit 'Run'.

%% Specifications

% Path to the processed image data folder (e.g. proc_data)
inputDTI.in_path = "/Volumes/path/to/proc_data";

% Observation days (e.g. "P1" etc.)
inputDTI.days = ["Baseline","P7","P14","P28","P42","P56"];

% Groups (e.g. "Sham" etc.)
inputDTI.groups = ["Group1", "Group2"];

% Threshold (0-1)
thres = 0;

% Output path 
inputDTI.out_path = "/Volumes/path/to/desired/output";

%% Do not modify the following lines
% This script tests the existence of the output path and consolidates all
% data only if the path does not exist. If the path already exists only
% the struct inputDTI and the cell matrices graphCell, matrixValues and ids
% will be created, which are necessary for several analysis functions.

addpath('../Tools/NIfTI/')
addpath('./GraphEval/')
if ~exist(inputDTI.out_path,'dir')
    mkdir(inputDTI.out_path)
    getMergedDTI_data(inputDTI,thres);
end
[graphCell,matrixValues,ids]=graphAnalysis_DTI(inputDTI);
acronyms = load('../Tools/infoData/acronyms_splitted.mat').acronyms;
