%����˵����DrawIMFs������EMD�е��ã���������EMD�ֽ��õ���IMFs����

close all;
clear;
clc;

result_Path =  'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\';  %����õ��ı���ģ̬����λ��  
num_roi = 22;                                % ����Ȥ����ĸ���������raw_roi�ṹ���е����ݾ��帳ֵ
num_vol = 1018;                              % ʱ�����������ݽṹ���ڵ�time���帳ֵ
ts = 1/500;                               %���ʱ����������е�time����
fs = 1/ts;   
t = 0:ts:ts*(num_vol-1); % tsΪʱ������fsΪ����Ƶ�ʡ�tΪʱ�䳤��0-2.0s
load([result_Path,'AllSubjects_imf.mat']);
num_subj=16;   

 %function  Draw=DrawIMFs(t,ts,imf,num_subj,num_roi)
 
    signal=[];%����һ���ռ���ʱ�洢��ͼROI����

for i = 1:num_subj                                              % ��ѭ��Ϊ������
    for j = 1:num_roi                                           % ��ѭ��Ϊ����Ȥ�������Ŀ
    signal = imf{i,1}{1,j};   %��ȡSubject i �еĵ�j��ROI
    signal=signal.'   ;  %����ת�����ڻ�ͼ
    m=size(signal,1);    %��ȡIMF����
    figure('visible','off');%����figure����������ʾ
      for k=1:m
          subplot(m,1,k);
          plot(t,signal(k,:),'b') ;
          title(['Subject',num2str(i),' ','ROI',num2str(j),' ','IMF',num2str(k)]);
      end  
          cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\IMFsFigure\');%����ͼƬ�洢λ��
          fig=gcf;
          print(fig,'-dpng');
    end
end   
