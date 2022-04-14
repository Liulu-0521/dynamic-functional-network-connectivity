%函数说明：DrawIMFs函数在EMD中调用，用来绘制EMD分解后得到的IMFs函数

close all;
clear;
clc;

result_Path =  'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\';  %结果得到的本征模态函数位置  
num_roi = 22;                                % 感兴趣区域的个数，根据raw_roi结构体中的数据具体赋值
num_vol = 1018;                              % 时间点个数，根据结构体内的time具体赋值
ts = 1/500;                               %间隔时间根据数据中的time决定
fs = 1/ts;   
t = 0:ts:ts*(num_vol-1); % ts为时间间隔、fs为采样频率、t为时间长度0-2.0s
load([result_Path,'AllSubjects_imf.mat']);
num_subj=16;   

 %function  Draw=DrawIMFs(t,ts,imf,num_subj,num_roi)
 
    signal=[];%开辟一个空间临时存储绘图ROI数据

for i = 1:num_subj                                              % 外循环为被试数
    for j = 1:num_roi                                           % 内循环为感兴趣区域的数目
    signal = imf{i,1}{1,j};   %提取Subject i 中的第j个ROI
    signal=signal.'   ;  %矩阵转置用于绘图
    m=size(signal,1);    %获取IMF数量
    figure('visible','off');%绘制figure但不弹窗显示
      for k=1:m
          subplot(m,1,k);
          plot(t,signal(k,:),'b') ;
          title(['Subject',num2str(i),' ','ROI',num2str(j),' ','IMF',num2str(k)]);
      end  
          cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\IMFsFigure\');%设置图片存储位置
          fig=gcf;
          print(fig,'-dpng');
    end
end   
