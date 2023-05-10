%% First Steps
% Consolidates all graph-theoretical measures of the processed DTI-data. 
% Please specify all information below and hit 'Run'.
%% Specifications

% Path to the processed image data folder (e.g. proc_data)
inputDTI.in_path =  "C:\Users\aswen\Desktop\TestingFolder\Test_dataset\docker_pc_version2";

% Observation days (e.g. "P1" etc.)
inputDTI.days = ["P1", "P2"]; 

% Groups (e.g. "Sham" etc.)
%inputDTI.groups = ["S1"];
inputDTI.groups = ["S1"];
% Threshold Type (0: Fixed, 1: Density-based)
thres_type = 1;

% Threshold (0-1)
% For the Density-based threshold, this is the proportion of
% the biggest weights to preserve
thres = 0.3;

% Output path 
inputDTI.out_path =  "C:\Users\aswen\Desktop\TestingFolder\Test_dataset\docker_pc_version2\DTIoutput";
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
