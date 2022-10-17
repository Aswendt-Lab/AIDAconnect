%% First Steps
% Consolidates all information of the processed T2-weighted MRI-data. 
% Please specify all information below and hit 'Run'.

%% Specifications

% Path to the processed image data folder (e.g. proc_data)
inputT2.in_path = "N:\Student_projects\14_Aref_Kalantari_2021\Projects\CRC_WP1\proc_data_sorted_timeline_2";
% Observation days (e.g. "P1" etc.)
inputT2.days = ["Baseline","P7","P14","P28"]; 

% Groups (e.g. "Sham" etc.)
inputT2.groups = ["Sham","Stroke"];

% Output path
inputT2.out_path = "N:\Student_projects\14_Aref_Kalantari_2021\Projects\CRC_WP1\proc_data_sorted_timeline_2\OutputT2w";

%% Do not modify the following lines
% This Script tests the existence of the output path and consolidates all
% data only if the path does not exist.

addpath('..\Tools\NIfTI\')
addpath('.\T2w_Processing\')
if ~exist(inputT2.out_path,'dir')
    mkdir(inputT2.out_path)  
    getMergedT2_data(inputT2);
end
acronyms = load('..\Tools\infoData\acronyms.mat').acronyms;
