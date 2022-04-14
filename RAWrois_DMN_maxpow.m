%程序说明：在提取每一个ROI的虚拟通道之后，采用最大功率法将一个ROI中的多个通道信号变成一个
%并将116个ROI信号进行合并
close all;
clear;
clc;
% SourcePath='E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\ReconSource\';%源重建信号的位置
resultPath = 'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\ROIsignal_maxpow\';%提取的ROI信号存放位置
% dataPath = 'E:\LiuluData\CTF\SourceData\HCP\DMN\Data\';%预处理data数据所在位置
% ModelPath='E:\LiuluData\CTF\SourceData\HCP\DMN\AAL\';%标准模型所在位置
ROIsignalPath='E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\ROIsignal\';%提取的116个脑区信号所在位置

subjList={'100307','102816','105923','106521','108323','109123','111514','113922','116524','133019','140117','146129','153732','156334','158136','162026'};                      %需要批量处理的数据名字
nSubj = length(subjList);

num_roi=116;
for i=1:nSubj
    
    for j=1:num_roi
    %加载每个被试的脑区ROI信号
    load([ROIsignalPath,subjList{i},'\',subjList{i},'_raw_',num2str(j)]);
    raw_rois.time=raw_oneroi.time;
    raw_rois.method='maxpow';
    num_trial=length(raw_oneroi.trial);
        for k=1:num_trial
            raw_rois.trial{1,k}(j,:) = maxpow(raw_oneroi.trial{1,k},raw_oneroi.time{1}(k));
            
        end
    
    end
    
     save([resultPath,subjList{i},'_RAWrois_maxpow_116','.mat'],'raw_rois');
    
end