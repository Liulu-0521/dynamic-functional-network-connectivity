%����˵��������DMN����Ҫ��ROI��116��ROI�н��г�ȡ����µ�ʱ����������Ϊ���Ե�DMN��ʱ������

close all;
clear;
clc;

resultPath = 'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\ROIsignal_DMN\';%��ȡ��DMN ROI�źŴ��λ��
ModelPath='E:\LiuluData\CTF\SourceData\HCP\DMN\';%����DMN label��Ϣ���ļ�����λ��
ROImaxpowsignalPath='E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\ROIsignal_maxpow\';%��ȡ��116������������ź�����λ��

subjList={'100307','102816','105923','106521','108323','109123','111514','113922','116524','133019','140117','146129','153732','156334','158136','162026'};                      %��Ҫ�����������������
nSubj = length(subjList);

DMN_num={3,4,7,8,11,12,31,32,33,34,35,36,37,38,39,40,65,66,67,68,85,86};%��maxpow�ź�����ȡ��Щ��ŵ�ʱ���ź�
%����ľ�̬������ֵ
num_roi=length(DMN_num);%22��

load([ModelPath,'DMN_ROIs','.mat']);

for i=1:nSubj
    load([ROImaxpowsignalPath,subjList{i},'_RAWrois_maxpow_116','.mat']);
    DMN_rois.time=raw_rois.time;
    DMN_rois.method=raw_rois.method;
    DMN_rois.label=DMN_ROIs.label;
    DMN_rois.atlas='AAL';
    
    for j=1:num_roi
    %����ÿ�����Ե�����ROI�ź�
    num_trial=length(raw_rois.trial);
        for k=1:num_trial
            DMN_rois.trial{1,k}(j,:) = raw_rois.trial{1,k}(DMN_num{j},:);    
        end
    
    end
    
     save([resultPath,subjList{i},'_RAWrois_maxpow_DMN','.mat'],'DMN_rois');
    
end