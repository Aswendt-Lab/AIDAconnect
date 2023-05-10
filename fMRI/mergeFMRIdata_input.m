%% First Steps
% Consolidates all graph-theoretical measures of the processed rsfMRI-data. 
% Please specify all information below and hit 'Run'.

%% Specifications

% Path to the processed image data folder (e.g. proc_data)
inputFMRI.in_path = "C:\Users\aswen\Documents\Data\CRC_WP1\inputs\mri\proc_data"

% Observation days e.g. “P1" etc.
inputFMRI.days = ["Baseline","P1","P7","P14","P21","P28"];

% Groups e.g. “Sham” etc.
inputFMRI.groups = ["StrokeBad","Sham"];
inputFMRI.groups = ["StrokeBad","StrokeGood"];
% Threshold Type (0: Fixed, 1: Density-based)
thres_type = 1;

% Threshold (0-1)
% For the Density-based threshold, this is the proportion of
% the biggest weights to preserve
thres = 0.3;
 
% Output path 
inputFMRI.out_path = "C:\Users\aswen\Documents\Data\CRC_WP1\outputs\AIDAconnet_results\outputFMRI_FixedBased_10percent_SliceTimeCorrected_data";
%% Do not modify the following lines
% This Script tests the existence of the output path and consolidates all
% data only if the path does not exist. If the path already exists only
% the struct inputFMRI and the cell matrices graphCell, matrixValues and ids
% will be created, which are necessary for several analysis functions.
addpath('..\Tools\NIfTI\')
addpath('.\rsfMRI_Processing\')
if ~exist(inputFMRI.out_path,'dir')
    mkdir(inputFMRI.out_path)  
    getMergedFMRI_data(inputFMRI,thres_type,thres);
end
[graphCell,matrixValues,ids]=graphAnalysis_fMRI(inputFMRI);
acronyms = load('..\Tools\infoData\acronyms_splitted.mat').acronyms;
