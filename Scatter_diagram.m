%函数说明：绘制不同状态下极坐标的散点图
clear
clc
close all

% % % 健康被试
% % % 健康被试
% load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Ang_cluster.mat')          % 加载Ang_cluster
% load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Coh_cluster.mat')          % 加载Coh_cluster
% load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\Time_FrequencyCluster\Time_FrequencyCluster.mat') % 加载ClusterResult
load('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\317\5_7Cluster.mat')


set(0,'defaultfigurecolor','w');                     % Set background white
num_roi = 22;
num_cluster = 5;
coh = cell(num_cluster,1);
ang = cell(num_cluster,1);
fname = {'State-1','State-2','State-3','State-4','State-5'};
for i = 1:num_cluster
    
    coh = C_inall{89}(i,1:num_roi*num_roi); % cluster centroids for coherence
    coh(coh==0) = [];
    coh(coh==1) = [];
    
    ang = C_inall{89}(i,num_roi*num_roi+1:2*num_roi*num_roi); % cluster centroids for phase
    ang(ang==0) = [];
    
    figure(i);
    polarscatter(ang,coh,'.');
    
    thetaticks([0 45 90 135 180 225 270 315])
    thetaticklabels({'0','\pi/4','\pi/2','3\pi/4','\pm\pi','-3\pi/4','-\pi/2','-\pi/4'})
    
    ax = gca;
    ax.FontSize = 4;
    rticklabels({})
    
%     cd('F:\HHT\Result\right_DMN\polarFigure')
%     cd('F:\HHT\Result\left_DMN\polarFigure')
cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\317\5-7max\')
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 1 1];
    tmp = [fname{i} '_Phase-Lag'];
    print(tmp,'-dpng','-r300');

%     close
end

