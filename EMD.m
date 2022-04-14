%������Դ��HCP���ݿ�
%����״̬����������ʷ���ȡ��Ϣ״̬��78�����ź�
%�������ܣ�������ȡ��RIO�źŽ��лƱ任�ĵ�һ������ģ̬�ֽ�
clear;
clc;
%����·������
data_Path = 'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\ROIsignal_DMN\';%��ȡ��ROIλ��
result_Path =  'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\';  %����õ��ı���ģ̬����λ��  

%�����õ��ľ�Ϣ̬������ֵ
num_roi = 22;                                % ����Ȥ����ĸ���������raw_roi�ṹ���е����ݾ��帳ֵ
num_vol = 1018;                              % ʱ�����������ݽṹ���ڵ�time���帳ֵ
ts = 1/500;  
fs = 1/ts;   
t = 0:ts:ts*(num_vol-1); % tsΪʱ������fsΪ����Ƶ�ʡ�tΪʱ�䳤��0-2.0s
%Sub_name='100307_RAWrois_maxpow_1.mat';   %����Ȥ���ļ���

subjList={'100307','102816','105923','106521','108323','109123','111514','113922','116524','133019','140117','146129','153732','156334','158136','162026'};                      %��Ҫ�����������������
num_subj=length(subjList);                               %��Ҫ������������ݸ���

%�������ݣ�ȡ��roi�źŵĵ����trial���źŽ��к�������
signal=cell(num_subj,1);%����Ԫ������ռ�
for i = 1:num_subj 
    load([data_Path,subjList{i},'_RAWrois_maxpow_DMN.mat']);   % ����ÿ�����Ե�Դ�ؽ����MEG����
    signal{i} = DMN_rois.trial{1,5};                         % ����5��trial��ʱ��������ΪҪ������ź�
     signal{i} = abs(hilbert(signal{i}));                     % ��ȡ�źŵķ��Ȱ���
     signal{i} = zscore(signal{i});                           % zscore���ڱ�׼�����൱��z = (x-mean(x))./std(x)
end
clearvars i                                                  % �������i

save( [result_Path,'AllSubjects', '_signal.mat'],'signal')                   % ����׼������źű����ڽ��·����

%��ȡ����trial�źŽ��о���ģ̬�ֽ�EMD�õ�����ģ̬����IMFs
imf = cell(num_subj,1);                                         %Ϊ���������ı���ģ̬�������ٴ洢�ռ�
for i = 1:num_subj                                              % ��ѭ��Ϊ������
    for j = 1:num_roi                                           % ��ѭ��Ϊ����Ȥ�������Ŀ
       imf{i}{j} = emd(signal{i}(j,:),'Interpolation','pchip','Display',0);%,'Display',0);% ��ÿ�����Ե�ÿ������Ȥ������źŽ���EMD�ֽ⣬ÿ�������ֽ�õ�6~8��IMFs�źţ�ÿ��һ��IMF�źţ�    
    end   
end
clearvars i j                                                        % �������i��j

save( [result_Path,'AllSubjects','_imf.mat'],'imf');                                % ��IMFs�źű����ڽ��·����

%��ͼROI�ֽ�ΪIMFs�ĺ���
%DrawIMFs(t,ts,imf,num_subj,num_roi);

%�����ʾÿ������Ȥ���źű��ֽ��6~8��IMFs�źţ�
%matlabĬ�ϵ�sifting stops when current relative tolerance is less than SiftRelativeTolerance
%SiftRelativeToleranceĬ��ֵΪ0.2
%����ֽ�õ���IMFs�ź���Դ�źŵ�Ƥ��ɭ���
%CoIMFsSignal(imf,signal,num_subj,num_roi);