% %����˵��������subj 1��roi 8���ź�ͼ��˲ʱƵ�ʡ�˲ʱ��λͼ��Ƶ����λͼ
close all;
clear;
clc;

result_Path =  'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\';  %Hilbert�任֮��õ���˲ʱƵ�ʡ���λ������λ��
IMF_Path='E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\';%����ģ̬����λ��
num_roi = 22;                                % ����Ȥ����ĸ���������raw_roi�ṹ���е����ݾ��帳ֵ
num_vol = 1018;                              % ʱ�����������ݽṹ���ڵ�time���帳ֵ
ts = 1/500;                               %���ʱ����������е�time����
fs = 1/ts;   
t = 0:ts:ts*(num_vol-1); % tsΪʱ������fsΪ����Ƶ�ʡ�tΪʱ�䳤��0-2.0s
load([result_Path,'AllSubjects_hilbertAmplitude']);
load([result_Path,'AllSubjects_hilbertFrequency']);
load([IMF_Path,'AllSubjects_imf']);
num_subj=16;   

 %function  Draw=DrawIMFs(t,ts,imf,num_subj,num_roi)
 
    signal_F=[];%����һ���ռ���ʱ�洢��ͼROI����
    signal_A=[];%
    signal=[];


    signal_A = Amp{1,1}{1,8};   %��ȡSubject i �еĵ�j��ROI
    signal_A=signal_A.'   ;  %����ת�����ڻ�ͼ
    signal_F=Freq{1,1}{1,8}; 
    signal_F=signal_F.';
    signal=imf{1,1}{1,8};
    signal=signal.';
     m=5;%m=size(signal,1);    %��ȡIMF����
%     signal_F_2=[];
%     for i=1:m
%         signal_F_1=sort(signal_F(i,:));
%         signal_F_2=[signal_F_2;signal_F_1];
%     end
%     signal_F=signal_F_2;
    figure('visible','off');%����figure����������ʾ
      for k=1:m
          subplot(m,1,k);
          plot(t,signal_A(k,1:1018),'g') ;
%           ylabel('Amplitude','FontSize',12);
%            xlabel('Time','FontSize',12);
          title(['Subject',num2str(1),' ','ROI',num2str(8),' ','IMF',num2str(k)],'FontSize',12);
      end  
          cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\');%����ͼƬ�洢λ��
          fig=gcf;
          print(fig,'-dpng');
       
           figure('visible','off');%����figure����������ʾ
      for k=1:m
          subplot(m,1,k);
          plot(t,signal_F(k,1:1018),'b') ;
%           ylabel('Frequency');
%            xlabel('Time');
          title(['Subject',num2str(1),' ','ROI',num2str(8),' ','IMF',num2str(k)],'FontSize',12);
      end  
          cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\');%����ͼƬ�洢λ��
          fig=gcf;
          print(fig,'-dpng');
          
%  figure('visible','off');%����figure����������ʾ
%       for k=1:m
%           subplot(m,1,k);
%           plot(t,signal(k,1:1018),'r') ;
%          % ylabel('Frequency');
%            xlabel('Time');
%           title(['Subject',num2str(1),' ','ROI',num2str(8),' ','IMF',num2str(k)]);
%       end  
%           cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\');%����ͼƬ�洢λ��
%           fig=gcf;
%           print(fig,'-dpng');
          
             figure('visible','off');%����figure����������ʾ
      for k=1:m
          subplot(m,1,k);
          plot(signal_F(k,1:1018),signal_A(k,1:1018),'m.') ;
%           ylabel('Amplitude');
%           xlabel('Frequency');
          title(['Subject',num2str(1),' ','ROI',num2str(8),' ','IMF',num2str(k)],'FontSize',12);
      end  
          cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\');%����ͼƬ�洢λ��
          fig=gcf;
          print(fig,'-dpng');
   
   

