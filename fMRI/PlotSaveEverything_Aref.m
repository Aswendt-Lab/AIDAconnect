savePath = "C:\Users\aswen\Documents\Data\CRC_WP1\outputs\AIDAconnet_results\outputFMRI_FixedBased_10percent_SliceTimeCorrected_data\Figures";
strParameter = {'Degree', 'Eigenvector', 'Betweenness', 'Strength', 'Clustercoefficient', 'Participationcoefficient','Efficiency'}
acronyms = tempFile.acronyms;
for aa = 1:length(acronyms)
    for i = 1:length(strParameter)
        plotLocalParameter(inputFMRI, graphCell, acronyms(aa), strParameter{i})
        figName = sprintf('%s_%s.png', acronyms(aa), strParameter{i});
        saveas(gcf, fullfile(savePath,figName));
        close(gcf);
    end
end