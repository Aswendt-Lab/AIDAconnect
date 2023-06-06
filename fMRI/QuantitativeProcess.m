%% General Info
% Author: A.Kalantari
% arefks@gmail.com

%% First Steps
% Consolidates all graph-theoretical measures of the processed rsfMRI-data. 
% Please specify all information below and hit 'Run'.
clc
clear
%% Specifications
% Observation days e.g. “P1" etc.
inputFMRI.days = ["Baseline","P1","P7","P14","P21","P28"];
% Groups e.g. “Sham” etc.
inputFMRI.groups = ["StrokeGood","StrokeBad","Sham"];
% path where the results where saved 
inputFMRI.out_path = "C:\Users\aswen\Documents\Data\CRC_WP1\outputs\AIDAconnet_results\outputFMRI_DensityBased_30percent_SliceTimeCorrected_data";

%% Do not modify the following lines
% This Script tests the existence of the output path and consolidates all
% data only if the path does not exist. If the path already exists only
% the struct inputFMRI and the cell matrices graphCell, matrixValues and ids
% will be created, which are necessary for several analysis functions.
addpath('..\Tools\NIfTI\')
addpath('.\rsfMRI_Processing\')
[graphCell,matrixValues,ids]=graphAnalysis_fMRI(inputFMRI);
acronyms = load('..\Tools\infoData\acronyms_splitted.mat').acronyms;
%% Applying modified functions


Tables = ConnectionWeight(inputFMRI, graphCell, 'L PTLp', 'R MOp')
M_final = []

for tt=1:length(Tables)
    T = Tables{tt};
    M = table2array(T)';
    S(tt) = size(M,2)
end
mm = ceil(max(S)/10)*10;
for tt=1:length(Tables)
    T = Tables{tt};
    M = table2array(T)';
    M_bigger = nan(size(M,1),mm)
    M_bigger(:,1:length(M)) = M
    M_final = [M_final,M_bigger]
end






















