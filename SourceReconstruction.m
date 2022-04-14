%����˵��������������������Ԥ�����MEG���ݵĻ����ϣ�����Դ�ؽ���SourceReconstruction��
%��Դ�ؽ��õ���ʱ���ź���AALģ����в�ֵ
close all;
clear;
clc;

ModelPath='E:\LiuluData\CTF\SourceData\HCP\DMN\';%��׼ģ������λ��
dataPath = 'E:\LiuluData\CTF\SourceData\HCP\DMN\Data\';%Ԥ������������λ��
SourcemodelPath='E:\LiuluData\CTF\SourceData\HCP\DMN\Sourcemodel\';%Դģ������λ��
HeadmodelPath='E:\LiuluData\CTF\SourceData\HCP\DMN\Headmodel\';%ͷģ������λ��
resultPath = 'E:\LiuluData\CTF\SourceData\HCP\DMN\ROIsignal\';%��ȡ��ROI�źŴ��λ��

subjList={'100307','102816','105923','106521','108323','109123','111514','113922','116524','133019','140117','146129','153732','156334','158136','162026'};                      %��Ҫ�����������������
nSubj = length(subjList);

for subjNum = 1:nSubj
    %% make dir
%     mkdir([resultPath,subjList{subjNum}])
    
    %% load data
    
    %load headmodel of subject:vol
    load([HeadmodelPath,subjList{subjNum},'_MEG_anatomy_headmodel.mat']);

    %load sourcemodel of subject,source distribution is irregular:lead field
    load([SourcemodelPath,subjList{subjNum},'_MEG_anatomy_sourcemodel_3d8mm.mat']);
    
    %load raw data: meg data
    load([dataPath,subjList{subjNum},'_MEG_3-Restin_rmegpreproc.mat']);
    

    %load standard sourcemodel,source distribution is regular
    load([ModelPath,'standard_sourcemodel3d8mm.mat']);

    %load ROIs
    %load([ModelPath,'DMN_ROIs.mat']);

    %read atlas
    atlas = ft_read_atlas([ModelPath,'AAL\ROI_MNI_V4.nii']);

    %convert units
    vol = ft_convert_units(headmodel,'cm');
    grid = ft_convert_units(sourcemodel3d,'cm');
    sourcemodel = ft_convert_units(sourcemodel,'cm');
    atlas = ft_convert_units(atlas,'cm');
    grad = ft_convert_units(data.grad,'cm');
    
%     for megBand = 1:size(bandList,2)
        % make dir
%     mkdir([resultPath,subjList{subjNum},'\',bandList{1,megBand}])
    %mkdir([resultPath,subjList{subjNum}]);


   %% select MEG channels
%     megchannel = ft_channelselection('MEG', data.label);
%     chansel = match_str(data.label, megchannel);
% 
%     % preprocessing:bandfilter
%     cfg = [];
%     cfg.bpfilter = 'yes';
%     cfg.bpfreq = bandList{2,megBand};
%     data = ft_preprocessing(cfg,data);

    %timelockanalysis
    cfg = [];
    cfg.channel = 'MEG';
    cfg.covariance = 'yes';
   cfg.covariancewindow = 'all';
    cfg.vartrllength = 2;
    timelock = ft_timelockanalysis(cfg,data);
    
    
     %% select MEG channels
    megchannel = ft_channelselection('MEG', data.label);
    chansel = match_str(data.label, megchannel);

    %sourceanalysis
    cfg = [];
    cfg.channel = megchannel;
    cfg.method = 'lcmv';
    cfg.grid = grid;
    cfg.headmodel = vol;
    cfg.senstype = 'MEG';
    cfg.lcmv.normalize    = 'yes';
    cfg.lcmv.projectnoise = 'yes';
    cfg.lcmv.keepfilter   = 'yes';
    cfg.lcmv.fixedori     = 'yes';
    cfg.keepleadfield = 'yes';
    source = ft_sourceanalysis(cfg,timelock);

    %interpolates source activity or statistical maps onto the voxels or vertices of an anatomical description of the brain
    cfg = [];
    cfg.parameter = 'tissue';
    cfg.intermethod = 'nearest';
    sourcemodel = ft_sourceinterpolate(cfg,atlas,sourcemodel);
    source.tissue = sourcemodel.tissue;
     save([resultPath,subjList{subjNum},'_source','.mat'],'source');
%     save([resultPath,subjList{subjNum},'\',subjList{subjNum},'_source','.mat'],'source')
    
%     [pli_mat , raw_rois ] = ROI( data , source , ROIs);
% %     save([resultPath,subjList{subjNum},'\',bandList{1,megBand},'\',subjList{subjNum},'_RAWrois','.mat'],'raw_rois');
%     save([resultPath,subjList{subjNum},'_RAWrois','.mat'],'raw_rois');
end