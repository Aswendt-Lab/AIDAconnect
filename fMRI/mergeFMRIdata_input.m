%% First Steps
% Consolidates all graph-theoretical measures of the processed rsfMRI-data. 
% Please specify all information below and hit 'Run'.

%% Specifications

% Path to the processed image data folder (e.g. proc_data)
inputFMRI.in_path = "/Users/Username/Documents/Projects/proc_data";
 
% Observation days (e.g. "P1" etc.)
inputFMRI.days = ["Baseline","P7","P14","P28","P42","P56"];
 
% Groups (e.g. "Sham" etc.)
inputFMRI.groups = ["GroupName1","GroupName2"];
 
% Threshold (0-1)
thres = 0.1;
 
% Output path 
inputFMRI.out_path = "/Users/Username/Documents/Projects/proc_data/outputFMRI";

%% Do not modify the following lines
% This Script tests the existence of the output path and consolidates all
% data only if the path does not exist. If the path already exists only
% the struct inputFMRI and the cell matrices graphCell, matrixValues and ids
% will be created, which are necessary for several analysis functions.

addpath('../Tools/NIfTI/')
addpath('./rsfMRI_Processing/')
if ~exist(inputFMRI.out_path,'dir')
    mkdir(inputFMRI.out_path)  
    getMergedFMRI_data(inputFMRI,thres);
end
[graphCell,matrixValues,ids]=graphAnalysis_fMRI(inputFMRI);
