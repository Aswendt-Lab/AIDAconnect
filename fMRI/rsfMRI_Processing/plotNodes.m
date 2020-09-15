function plotNodes(graphCell,inputFMRI,limits,options,displayOptions)

%% plotNodes
% This function is used by plotSelectedRegions.m and is not meant to be
% used manually. It displays a selected subnetwork as a graph. 

titStr = inputFMRI; % = inputFMRI.days

for i = 1:length(titStr)
    subplot(2,4,i)
    if displayOptions == 1
        LWidths = 5*graphCell{i}.Edges.Weight/max(graphCell{i}.Edges.Weight);
    else
        LWidths = 3;
    end
    p_R = plot(graphCell{i},'XData',graphCell{i}.Nodes.XCoord,...
        'YData',-graphCell{i}.Nodes.YCoord,'MarkerSize',15,...
        'LineWidth',LWidths,...
        'EdgeColor', '#696969'); %'EdgeLabel',round(G_stroke{i}.Edges.Weight));
    graphCell{i}.Nodes.allStrength(graphCell{i}.Nodes.allStrength==0)=1;
    if displayOptions == 1
        p_R.MarkerSize = 15*mean(graphCell{i}.Nodes.allStrength,2)/mean(max(graphCell{i}.Nodes.allStrength));
    else
        p_R.MarkerSize = 15;
    end
    switch(lower(options))
        case 'degree'
            selLimits = limits{1};
            p_R.NodeCData = mean(graphCell{i}.Nodes.allDegree,2); % Over all subjects
        case 'strength'
            selLimits = limits{3};
            p_R.NodeCData = mean(graphCell{i}.Nodes.allStrength,2);                               
        otherwise
            break
    end
    title(titStr(i),'FontSize', 20);
    caxis(selLimits) 
    hold on
    axis off
    nl = p_R.NodeLabel;
    p_R.NodeLabel='';
    xd = get(p_R, 'XData');
    yd = get(p_R, 'YData');
    zd = get(p_R, 'ZData');
    text(xd+2, yd, zd, nl, 'FontSize', 10);
end

subplot('Position', [0.59 0.13 0.255 0.215])
    view([90 90]);
    annotation('textbox', [0.595, 0.24, 0.1, 0.1], 'string', ...
        "Circle diameter:", 'FontWeight', 'bold', ...
        'FontSize', 10, 'EdgeColor', 'none');
    annotation('textbox', [0.595, 0.21, 0.1, 0.1], 'string', ...
        "Min. Avg. Node Strength: "+round(limits{3}(1)), ...
        'FontSize', 10, 'EdgeColor', 'none');    
    annotation('textbox', [0.595, 0.18, 0.1, 0.1], 'string', ...
        "Max. Avg. Node Strength: "+round(limits{3}(2)), ...
        'FontSize', 10, 'EdgeColor', 'none');
    annotation('textbox', [0.595, 0.14, 0.1, 0.1], 'string', ...
        "Line thickness:", 'FontWeight', 'bold', ...
        'FontSize', 10, 'EdgeColor', 'none');
    annotation('textbox', [0.595, 0.11, 0.1, 0.1], 'string', ...
        "Min. Edge Weight: "+round(limits{2}(1)), ...
        'FontSize', 10, 'EdgeColor', 'none');
    annotation('textbox', [0.595, 0.08, 0.1, 0.1], 'string', ...
        "Max. Edge Weight: "+round(limits{2}(2)), ...
        'FontSize', 10, 'EdgeColor', 'none');
    box on
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    set(gca,'TickLength', [0, 0]);
    c=colorbar;
    c.Position = [0.86  0.13  0.03  0.31]; % [x-Pos y-Pos Width Height]
    switch(lower(options))
        case 'degree'
            c.Label.String = "Mean Degree";
        case 'strength'
            c.Label.String = "Mean Strength";
    end
    c.Label.FontSize = 10;
    colormap autumn;
    caxis(selLimits);
return


