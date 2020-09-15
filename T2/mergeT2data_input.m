%% First Steps
% Consolidates all information of the processed T2-weighted MRI-data. 
% Please specify all information below and hit 'Run'.

%% Specifications

% Path to the processed image data folder (e.g. proc_data)
inputT2.in_path = "/Users/Username/Documents/Projects/proc_data";

% Observation days (e.g. "P1" etc.)
inputT2.days = ["Baseline","P1","P7","P14","P21","P28"]; 

% Groups (e.g. "Sham" etc.)
inputT2.groups = ["GroupName1","GroupName2"];

% Output path 
inputT2.out_path = "/Users/Username/Documents/Projects/proc_data/outputT2w";

%% Do not modify the following lines
% This Script tests the existence of the output path and consolidates all
% data only if the path does not exist.

addpath('../Tools/NIfTI/')
addpath('./T2w_Processing/')
if ~exist(inputT2.out_path,'dir')
    mkdir(inputT2.out_path)  
    getMergedT2_data(inputT2);
end