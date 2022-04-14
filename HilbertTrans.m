%根据程序CoIMFsSignal的分析可以得到，ROIs分解得到的IMFs中，前5个IMFs与源信号相关性最强
%本程序取每个ROI的前5个IMFs进行Hilbert变换
%并计算各IMF经过Hilbert变换后在各个时间点的瞬时幅度，相位，频率
close all;
clear;
clc;

%加载所需要的IMFs数据
IMFs_Path =  'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\';  %所有被试的IMFs信号位置
Hilbert_Path= 'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\';%Hilbert变换的到的所有结果的位置                        
load([IMFs_Path,'AllSubjects_imf.mat']);

%静态变量赋值
num_roi =22;  %感兴趣区个数，根据实际调整
num_subj=16;  %被试个数 
num_vol=1018; %时间点个数，根据数据的大小决定
num_imf=5;    %提取每个ROIs分解的前4个IMFs
ts = 1/500;   %各数据点的时间间隔


%计算各IMFs分量的Hilbert变换
hbt=cell(num_subj,1);%为imfs进行hilbert变换开辟空间
for i=1:num_subj
    for j=1:num_roi        
        imf_x = imf{i}{j}(:,1:num_imf);                         % 获取前num_imf(也就是前4)个，时间点数*imf数           
        hbt{i}{j} = hilbert(imf_x);                         % 希尔伯特变换：将信号从时域变换到时频域；获取imf_x的解析信号                   
    end   
end
save( [Hilbert_Path,'AllSubjects','_hilbert.mat'],'hbt')   

%计算各IMF的在各个时间点上的瞬时幅度、相位、频率
%瞬时幅度Amp，瞬时相位Pha，瞬时频率Freq
Amp=cell(num_subj,1);
for i=1:num_subj
    for j=1:num_roi        
        imf_x = imf{i}{j}(:,1:num_imf);                         % 获取前num_imf(也就是前4)个，时间点数*imf数           
        for k=1:num_imf
            for m=1:num_vol
                Amp{i}{j}(m,k) = abs(hbt{i}{j}(m,k));  %计算IMFs瞬时幅度值                                    
            end
        end 
    end
end
save( [Hilbert_Path,'AllSubjects','_hilbertAmplitude.mat'],'Amp')   %保存IMFs各点的瞬时幅度

Pha=cell(num_subj,1);
for i=1:num_subj
    for j=1:num_roi        
        imf_x = imf{i}{j}(:,1:num_imf);                         % 获取前num_imf(也就是前4)个，时间点数*imf数           
        for k=1:num_imf
            for m=1:num_vol
                Pha{i}{j}(m,k) = angle((hbt{i}{j}(m,k)));  %计算IMFs瞬时相位，单位为rad，范围+-π之间                                     
            end
        end 
    end
end
save( [Hilbert_Path,'AllSubjects','_hilbertPhase.mat'],'Pha')   


Freq=cell(num_subj,1);
for i=1:num_subj
    for j=1:num_roi        
        for k=1:num_imf
            Q(:,k)=unwrap(Pha{i}{j}(:,k));%暂时存储相位纠正数据
            Freq{i}{j}(:,k) = gradient(Q(:,k),ts);% 使用相角计算瞬时角频率              
        end 
    end
end
save( [Hilbert_Path,'AllSubjects','_hilbertFrequency.mat'],'Freq')   


%基于瞬时频率的希尔伯特加权频率HWF
HWF=cell(num_subj,1);
for i=1:num_subj
    for j=1:num_roi        
        for k=1:num_imf
            mol=0;
            den=0;
           for m=1:num_vol
               mol=mol+((Freq{i}{j}(m,k))*(( Amp{i}{j}(m,k))^2));%分子
               den=den+(( Amp{i}{j}(m,k))^2);%分母  
           end
            HWF{i}{j}(k)=mol/den;
        end 
    end
end
save( [Hilbert_Path,'AllSubjects','_hilbertHWF.mat'],'HWF')   

%基于瞬时幅度（能量）的希尔伯特加权平均频率HWMF
HWMF=cell(num_subj,1);
absolu=cell(num_subj,1);
for i=1:num_subj
    for j=1:num_roi        
        for k=1:num_imf
            mol=0;%分子
            den=0;%分母
            absol=0;%范数
           for m=1:num_vol
               absol=absol+abs(Amp{i}{j}(m,k));%范数
              
           end
            absolu{i}{j}(k)=absol;
            mol=mol+absolu{i}{j}(k)*HWF{i}{j}(k);
            den=den+absolu{i}{j}(k);
          
        end 
          HWMF{i}{j}=mol/den;
    end
end
save( [Hilbert_Path,'AllSubjects','_hilbertHWMF.mat'],'HWMF')   