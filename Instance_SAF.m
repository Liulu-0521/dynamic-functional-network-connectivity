% %函数说明：绘制subj 1，roi 8的信号图、瞬时频率、瞬时相位图、频率相位图
close all;
clear;
clc;

result_Path =  'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\';  %Hilbert变换之后得到的瞬时频率、相位、幅度位置
IMF_Path='E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\';%本征模态函数位置
num_roi = 22;                                % 感兴趣区域的个数，根据raw_roi结构体中的数据具体赋值
num_vol = 1018;                              % 时间点个数，根据结构体内的time具体赋值
ts = 1/500;                               %间隔时间根据数据中的time决定
fs = 1/ts;   
t = 0:ts:ts*(num_vol-1); % ts为时间间隔、fs为采样频率、t为时间长度0-2.0s
load([result_Path,'AllSubjects_hilbertAmplitude']);
load([result_Path,'AllSubjects_hilbertFrequency']);
load([IMF_Path,'AllSubjects_imf']);
num_subj=16;   

 %function  Draw=DrawIMFs(t,ts,imf,num_subj,num_roi)
 
    signal_F=[];%开辟一个空间临时存储绘图ROI数据
    signal_A=[];%
    signal=[];


    signal_A = Amp{1,1}{1,8};   %提取Subject i 中的第j个ROI
    signal_A=signal_A.'   ;  %矩阵转置用于绘图
    signal_F=Freq{1,1}{1,8}; 
    signal_F=signal_F.';
    signal=imf{1,1}{1,8};
    signal=signal.';
     m=5;%m=size(signal,1);    %获取IMF数量
%     signal_F_2=[];
%     for i=1:m
%         signal_F_1=sort(signal_F(i,:));
%         signal_F_2=[signal_F_2;signal_F_1];
%     end
%     signal_F=signal_F_2;
    figure('visible','off');%绘制figure但不弹窗显示
      for k=1:m
          subplot(m,1,k);
          plot(t,signal_A(k,1:1018),'g') ;
%           ylabel('Amplitude','FontSize',12);
%            xlabel('Time','FontSize',12);
          title(['Subject',num2str(1),' ','ROI',num2str(8),' ','IMF',num2str(k)],'FontSize',12);
      end  
          cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\');%设置图片存储位置
          fig=gcf;
          print(fig,'-dpng');
       
           figure('visible','off');%绘制figure但不弹窗显示
      for k=1:m
          subplot(m,1,k);
          plot(t,signal_F(k,1:1018),'b') ;
%           ylabel('Frequency');
%            xlabel('Time');
          title(['Subject',num2str(1),' ','ROI',num2str(8),' ','IMF',num2str(k)],'FontSize',12);
      end  
          cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\');%设置图片存储位置
          fig=gcf;
          print(fig,'-dpng');
          
%  figure('visible','off');%绘制figure但不弹窗显示
%       for k=1:m
%           subplot(m,1,k);
%           plot(t,signal(k,1:1018),'r') ;
%          % ylabel('Frequency');
%            xlabel('Time');
%           title(['Subject',num2str(1),' ','ROI',num2str(8),' ','IMF',num2str(k)]);
%       end  
%           cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\');%设置图片存储位置
%           fig=gcf;
%           print(fig,'-dpng');
          
             figure('visible','off');%绘制figure但不弹窗显示
      for k=1:m
          subplot(m,1,k);
          plot(signal_F(k,1:1018),signal_A(k,1:1018),'m.') ;
%           ylabel('Amplitude');
%           xlabel('Frequency');
          title(['Subject',num2str(1),' ','ROI',num2str(8),' ','IMF',num2str(k)],'FontSize',12);
      end  
          cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\');%设置图片存储位置
          fig=gcf;
          print(fig,'-dpng');
   
   

