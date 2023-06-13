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
inputFMRI.groups = ["Sham","StrokeBad","StrokeGood"];
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


Tables = ConnectionWeight(inputFMRI, graphCell, 'L MOp', 'R MOp');
Table_for_prism = []
Table_for_boxchart = []

%% Tables for Prism: Use Table_for_prism to copy paste the data into prism directly 
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
    Table_for_prism = [Table_for_prism,M_bigger];
    Table_for_boxchart = cat(3,Table_for_boxchart,M_bigger);
end
%% Table to use boxchart function
S = size(Table_for_boxchart);
GroupName=[];
TimeName=[];
Value = [];

for tt=1:S(1)
    for mm=1:S(2)
        for gg=1:S(3)
            GroupName= [GroupName;inputFMRI.groups(gg)];
            TimeName = [TimeName;inputFMRI.days(tt)];
            Value = [Value;Table_for_boxchart(tt,mm,gg)];
        end
    end
end

[p,tbl,stats,~] = anovan(Value,{GroupName,TimeName},"interaction");

[c,~,~,gnames] = multcompare(stats,"Dimension",[1 2]);




% 
% X_time = categorical(TimeName,inputFMRI.days);
% 
% boxchart(X_time,Value,'GroupByColor',GroupName)
% ylabel('ConnectionWegiht')
% legend()
% 
% 
% 






