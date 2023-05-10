function shortestPath(inputDTI, day2examine, startNode, endNode, groupAverage)

%% shortestPath
% This function displays the shortest path from one region to another.
% The shortest path is calculated as an inverse Dijkstra's Algorithm,
% meaning that this function seeks for the shortest path with the hightest 
% sum of fibers representing the best strengthened path.
% The output parameter 'Path Length' refers to the distance of the 
% indicated nodes calculated on the basis of the inverted number of 
% fibers. A lower value corresponds to a stronger connection.

% Input Arguments
% inputDTI from mergeDTIdata_input.m
% day2examine = Number of the day (as in the order of inputDTI.days)
% startNode = Begin of the path (as String)
% endNode = End of the path (as String)

% Optional Input Arguments
% groupAverage = You can either choose to display the mean shortest path
% of all groups (=1, default value) or choose to display the shortest path 
% for each subject of the groups (=0)

%% Examples
% shortestPath(inputDTI, 1, 'R sAMY', 'L SSs')
% shortestPath(inputDTI, 1, 'R sAMY', 'L SSs', 0)

%% Do not modify the following lines

if nargin == 4
    groupAverage = 1;
end

numberOfGroups = size(inputDTI.groups,2);
connMatrix = cell(1,numberOfGroups);
invMatrix = cell(1,numberOfGroups);

addpath('..\Tools\BCT');
load('..\Tools\infoData\acronyms_splitted.mat');

% Find the acronym-numbers of the specified regions
RegIDstartNode = find(acronyms == startNode);
RegIDendNode = find(acronyms == endNode);

for ii = 1:numberOfGroups
    tempFile = load(fullfile(inputDTI.out_path,inputDTI.groups(ii),[char(inputDTI.days(day2examine)) '.mat']));
    if groupAverage == 0
        numberOfSubjects = size(tempFile.infoDTI.matrix,3);
        for jj = 1:numberOfSubjects
            connMatrix{ii} = tempFile.infoDTI.matrix(:,:,jj);
            invMatrix{ii} = connMatrix{ii};
            % The algorithm for calculating the shortest path only accepts 
            % positive values. We therefore decided to replace negative 
            % numbers of fibers with 0 (just in case)
            invMatrix{ii}(connMatrix{ii}<=0) = 0;
            % The inverse matrix is some kind of connection length matrix, where small 
            % values refer to short distances (high connections)
            invMatrix{ii} = 1./invMatrix{ii};  
            [SPL,hops,Pmat] = distance_wei_floyd(invMatrix{ii});
            path = retrieve_shortest_path(RegIDstartNode,RegIDendNode,hops,Pmat);
            % Prepare the Output Presentation 
            pathSize = size(path,1);
            pathWithNames = strings(pathSize,1);
            % Replace the acronym-numbers with the actual region-names
            for i = 1:pathSize
                pathWithNames(i) = acronyms(path(i));
            end  
            pathWithNames_arrow = '';
            for j = 1:pathSize-1
                pathWithNames_arrow = strcat(pathWithNames_arrow,pathWithNames{j,1},"  ->  ");
            end
            pathWithNames_arrow = strcat(pathWithNames_arrow,pathWithNames{pathSize,1});
            disp('Shortest Path of subject '+string(tempFile.infoDTI.names(jj))+...
            ' in group '+inputDTI.groups(ii)+' at '+inputDTI.days(day2examine)+':');
            disp('    '+pathWithNames_arrow);
            disp('Path Length:');
            disp(SPL(RegIDstartNode,RegIDendNode));
        end
    else
        connMatrix{ii} = mean(tempFile.infoDTI.matrix,3);
        invMatrix{ii} = connMatrix{ii};
        invMatrix{ii}(connMatrix{ii}<=0) = 0;
        invMatrix{ii} = 1./invMatrix{ii};  
        [SPL,hops,Pmat] = distance_wei_floyd(invMatrix{ii});
        path = retrieve_shortest_path(RegIDstartNode,RegIDendNode,hops,Pmat);
        pathSize = size(path,1);
        pathWithNames = strings(pathSize,1);
        for i = 1:pathSize
            pathWithNames(i) = acronyms(path(i));
        end  
        pathWithNames_arrow = '';
        for j = 1:pathSize-1
            pathWithNames_arrow = strcat(pathWithNames_arrow,pathWithNames{j,1},"  ->  ");
        end
        pathWithNames_arrow = strcat(pathWithNames_arrow,pathWithNames{pathSize,1});
        disp('Shortest Path in Group '+inputDTI.groups(ii)+' at '+inputDTI.days(day2examine)+':');
        disp('    '+pathWithNames_arrow);
        disp('Path Length:');
        disp(SPL(RegIDstartNode,RegIDendNode));
    end
end
end