%% First Steps
% Consolidates all graph-theoretical measures of the processed rsfMRI-data.
% Please specify all information below and hit 'Run'.

%% Specifications

% Path to the processed image data folder (e.g. proc_data)
inputFMRI.in_path = "Z:\CRC_WP1\inputs\mri\proc_data";

% Observation days e.g. “P1" etc.
inputFMRI.days = ["P1","P7","P14","P21","P28"];

% Groups e.g. “Sham” etc.
inputFMRI.groups = ["Sham","StrokeGood","StrokeBad"];

% Threshold Type (0: Fixed, 1: Density-based)
thres_type = 0;

% Output path
inputFMRI.out_path = "Z:\CRC_WP1\outputs\AIDAconnet_results\outputFMRI_FixedBased_Allpercent_SliceTimeCorrected_data2";

% Threshold (0-1)
% For the Density-based threshold, this is the proportion of
% the biggest weights to preserve. For fixed based threshold everything
% thats under the threshold will be set to zero.
thres_begin = 0.5;
thres_end = 0.9;
Step = 0.1;
ParCompute = "Yes"; % Choose between "Yes" or "No" for parallel computation (faster)
%% Do not modify the following lines
% This Script tests the existence of the output path and consolidates all
% data only if the path does not exist. If the path already exists only
% the struct inputFMRI and the cell matrices graphCell, matrixValues and ids
% will be created, which are necessary for several analysis functions.

if ~exist(inputFMRI.out_path,'dir')
    mkdir(inputFMRI.out_path)
end
thres = thres_begin:Step:thres_end;

if ParCompute == "Yes"
     parpool(6)
    parfor ii = 1:numel(thres)
        infoFMRI = getMergedFMRI_data(inputFMRI,thres_type,thres(ii)); %% A saving process is implemented in the function. infofMRI can be used for developers.
    end
end

if ParCompute == "No"
    for ii = 1:numel(thres)
        infoFMRI = getMergedFMRI_data(inputFMRI,thres_type,thres(ii)); %% A saving process is implemented in the function. infofMRI can be used for developers.
    end
end









