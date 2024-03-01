%% First Steps
% Consolidates all information of the processed T2-weighted MRI-data. 
% Please specify all information below and hit 'Run'.

%% Specifications

% Path to the processed image data folder (e.g. proc_data)
inputT2.in_path = "/Users/schneiderm/Desktop/data_testing/proc_data";

% Observation days (e.g. "P1" etc.)
inputT2.days = ["Baseline","P3","P56"]; 

% Groups e.g. “Sham” etc.
inputT2.groups = ["Aref", "Marc"];

% Output path 
inputT2.out_path = "/Users/schneiderm/Desktop/data_testing/T2";

%% Do not modify the following lines
% This Script tests the existence of the output path and consolidates all
% data only if the path does not exist.

addpath('../Tools/NIfTI/')
addpath('./T2w_Processing/')
if ~exist(inputT2.out_path,'dir') || numel(dir(inputT2.out_path)) <= 2
    mkdir(inputT2.out_path)  
    getMergedT2_data(inputT2);
else
    f = msgbox("If you wish to process your data again, please delete the output folder manually.", "Attention");
end
acronyms = load('../Tools/infoData/acronyms_parental.mat').acronyms;