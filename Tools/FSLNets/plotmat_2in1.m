%
% plotmat_2in1
% plots in the lower triangle of the matrix one goup and in the other triangle another group
%
% Claudia Green, michaeld
% 2018-03-02
%
% plotmat_2in1(fnet1,fnet2,fnetimg,scminmax,labels);
%
% plotmat_2in1(fnet1,fnet2,fnetimg,scminmax,labels,fontsize);
%

function plotmat_2in1(fnet1,fnet2,fnetimg,scminmax,labels,varargin)

if nargin>5
    fontsize=varargin{1};
else
    fontsize=12;
end

% load matrix text files of both groups
mnet1=load(strcat(fnet1,'.txt'));
mnet2=load(strcat(fnet2,'.txt'));

% create a new matrix
tnet1=tril(mnet1);
tnet2=triu(mnet2);
mnet=tnet1 + tnet2;
[nrows,ncols]=size(mnet);

% set main diagonal to nan
mnet(1:nrows+1:numel(mnet)) = nan;

% plot as color-coded figure
%figure('position',[100 100 400 400]);
figure;

h=imagesc(mnet,scminmax); colormap(jet); colorbar; grid off;
set(h,'alphadata',~isnan(mnet));

if ~isempty(labels)
    if length(labels)==nrows
        set(gca,'XTick',1:ncols,'XTickLabel',labels,'XTickLabelRotation',45,'fontsize',fontsize,...
            'YTick',1:nrows,'YTickLabel',labels,'TickLength',[0 0],'fontsize',fontsize);
    else
        disp('Warning: Number of labels does not match with matrix size.')
    end
end

saveas(gcf,fnetimg,'tif');

% close all;

clear;
