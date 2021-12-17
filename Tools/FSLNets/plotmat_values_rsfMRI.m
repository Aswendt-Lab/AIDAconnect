%
% plotmat_values
% plots the upper triangle as numbers and lower triangle as colors

%
% Claudia Green, michaeld
% 2018-03-02
%
% plotmat_values(fnet,fnetimg,scminmax,showvalues,labels);
%
% plotmat_values(fnet,fnetimg,scminmax,showvalues,labels,fontsize);
%

function plotmat_values_rsfMRI(mnet,folder,dirInfo,scminmax,showvalues,labels,varargin)
saveplot = 0;


% load matrix text files of both groups
%mnet=load(fnet);

% lower triangle of the matrix
tnetl=tril(mnet);
[nrows,ncols]=size(mnet);

% make textfile to cellchars and empty lower part of matrix for plotting
textStrings=num2str(mnet(:),'%0.1f');
textStrings=strtrim(cellstr(textStrings));
textStrings=reshape(textStrings,nrows,ncols);
textStrings(logical(tril(ones(nrows,ncols))))={''};

% set main diagonal to nan
mnet(logical(eye(size(mnet))))=nan;

% plot matrix and save image
figure('position',[10 10 1200 1100]);
%figure;

if showvalues==0 % all colors
    h=imagesc(mnet,scminmax); colormap(jet); colorbar; grid off;
    set(h,'alphadata',~isnan(mnet));
else % upper triangle as numbers and lower triangle as colors
    h=imagesc(tnetl,scminmax); colormap(jet); colorbar; grid off;
    set(h,'alphadata',logical(tril(ones(nrows,ncols),-1)));
    [x,y]=meshgrid(1:ncols,1:nrows);
    text(x(:),y(:),textStrings(:),'HorizontalAlignment','center','fontsize',6);
end

if ~isempty(labels)
    if length(labels)==nrows
        fontsize=12;
        set(gca,'XTick',1:ncols,'XTickLabel',labels,'XTickLabelRotation',90,'fontsize',fontsize,...
            'YTick',1:nrows,'YTickLabel',labels,'TickLength',[0 0],'fontsize',fontsize);
    else
        disp('Warning: Number of labels does not match with matrix size.')
    end
end

if nargin==8
     X=varargin{1};
     Y=varargin{2};
    hold on
    plot(X,Y,'r','linewidth',2);
end


filename = dirInfo.name;
if saveplot == 1
fnetimg = strrep(filename,'.mat','.tif');
fname = strsplit(fnetimg,filesep);
fname = fname{end};
fnetimg = fullfile(folder,fname);
saveas(gcf,fnetimg,'tif');
nets_savemat_md(fullfile(dirInfo.folder, dirInfo.name) ,folder,tnetl,fname);
end

end
