%% First Steps
% Consolidates all graph-theoretical measures of the processed rsfMRI-data.
% Please specify all information below and hit 'Run'.
clc
clear
close all
%% Specifications

% Path to the processed image data folder i.e the outputfolder from the step before(e.g. proc_data)
inputPlot.in_path ="C:\Users\aswen\Documents\Data\Project_CRC\proc_data_processed\Results\outputFMRI";

% Observation days e.g. “P1" etc.
inputPlot.days = ["Baseline","P1","P7","P14","P21","P28"];

% Groups e.g. “Sham” etc.
inputPlot.groups = ["Sham","StrokeBad","StrokeGood"];

SavePlot = "off"; % If its "On", the corresponding figure(s) will be saved in the same input folder.
%% Do not modify the following lines
% This Script tests the existence of the output path and consolidates all
% data only if the path does not exist. If the path already exists only
% the struct inputFMRI and the cell matrices graphCell, matrixValues and ids
% will be created, which are necessary for several analysis functions.

for dd = 1:length(inputPlot.days)
    figure("Name",inputPlot.days(dd))
    for gg = 1:length(inputPlot.groups)
        Path = fullfile(inputPlot.in_path,inputPlot.groups(gg),strcat("*",inputPlot.days(dd),"_*"));
        files = dir(Path);
        for ff = 1:length(files)
            Path = fullfile(files(ff).folder,files(ff).name);
            load(Path);
            Data = infoFMRI;
            S =Data.strengths;
            M = mean(S,"all");
            Y(ff) = M;
            X(ff) = Data.density(1,1);
        end
        [~,I] = sort(X);
        plot(X(I),Y(I),"LineWidth",1,"Marker",".","LineStyle","-","MarkerSize",10)
        ylim([0 30])
        title(inputPlot.days(dd))
        ylabel("Mean Node Strength")
        xlabel("Density Threshold")
        hold on
        
    end
    legend(inputPlot.groups,"Location","northwest")
    hold off
end


if SavePlot == "On"
    figHandles = findall(0,'Type','figure');
    % Create filename
    fn = tempname(".");  %in this example, we'll save to a temp directory.

    % Save first figure
    export_fig(fn, '-pdf', figHandles(1))

    % Loop through figures 2:end
    for i = 2:numel(figHandles)
        export_fig(fn, '-pdf', figHandles(i), '-append')
    end

end












