%函数说明：根据DMN所需要的ROI从116个ROI中进行抽取组成新的时间序列组作为被试的DMN的时间序列

close all;
clear;
clc;

resultPath = 'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\ROIsignal_DMN\';%提取的DMN ROI信号存放位置
ModelPath='E:\LiuluData\CTF\SourceData\HCP\DMN\';%包含DMN label信息的文件所在位置
ROImaxpowsignalPath='E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\ROIsignal_maxpow\';%提取的116个脑区最大功率信号所在位置

subjList={'100307','102816','105923','106521','108323','109123','111514','113922','116524','133019','140117','146129','153732','156334','158136','162026'};                      %需要批量处理的数据名字
nSubj = length(subjList);

DMN_num={3,4,7,8,11,12,31,32,33,34,35,36,37,38,39,40,65,66,67,68,85,86};%从maxpow信号中提取这些序号的时间信号
%所需的静态变量赋值
num_roi=length(DMN_num);%22个

load([ModelPath,'DMN_ROIs','.mat']);

for i=1:nSubj
    load([ROImaxpowsignalPath,subjList{i},'_RAWrois_maxpow_116','.mat']);
    DMN_rois.time=raw_rois.time;
    DMN_rois.method=raw_rois.method;
    DMN_rois.label=DMN_ROIs.label;
    DMN_rois.atlas='AAL';
    
    for j=1:num_roi
    %加载每个被试的脑区ROI信号
    num_trial=length(raw_rois.trial);
        for k=1:num_trial
            DMN_rois.trial{1,k}(j,:) = raw_rois.trial{1,k}(DMN_num{j},:);    
        end
    
    end
    
     save([resultPath,subjList{i},'_RAWrois_maxpow_DMN','.mat'],'DMN_rois');
    
end