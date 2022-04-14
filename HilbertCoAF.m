%函数说明：在对每一个IMF进行Hilbert变换之后，得到IMF的幅度、相位、频率时间序列以及希尔比特加权频率值
%本函数对将这些时间序列作为ROI矩阵进行时频域相关性分析，得到ROI之间的相关矩阵和相位矩阵
close all;
clear;
clc;

%加载所需要的数据
Data_Path= 'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\';%Hilbert变换的到的所有结果的位置                        
load([Data_Path,'AllSubjects_hilbert.mat']);%加载经过Hilbert变换之后的数据
Result_Path='E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\';
%静态变量赋值
num_roi =22;  %感兴趣区个数，根据实际调整
num_subj=16;  %被试个数 
num_vol=1018; %时间点个数，根据数据的大小决定
num_imf=5;    %提取每个ROIs分解的前5个IMFs

Coherence = cell(num_subj,1);   %  相干矩阵
Phase = cell(num_subj,1);       %  相位矩阵

%计算被试i的第j个感兴趣区与第k个感兴趣区的时频域相关性，数据为经过hilbert变换之后的数据
for i = 1:num_subj              % 遍历被试数
%     tmp_coh=[];
    for j = 1:num_roi           % 遍历感兴趣区域数
        X=hbt{i}{j};            %将感兴趣区的4个IMF经过hilber变换之后的4个时间序列作为一个整体的矩阵
        for k=1:num_roi
            Y=hbt{i}{k};
             %%%% 分子
        Pxy = X.*conj(Y);                                   % X和Y的共轭相乘，构建交叉谱
%         tmp_ang(:,:,j,k) = angle(Pxy)';   %矩阵相位角，单位rad
%       Pxy = zscore(Pxy);                                  % 对Pxy进行归一化，使相干性估计不偏向于功率较大的信号部分
        sPxy = smooth(Pxy);                                 % 加入平滑函数，避免误差           
        sPxy = reshape(sPxy,num_imf,num_vol);
%          sPxy = reshape(sPxy,num_vol,num_imf)';
  %%% 分母
        Pxx = abs(X).^2;
        sPxx = smooth(Pxx);
%         sPxx=[sPxx;0];
%         sPxx=diff(sPxx);  %数据出现短缺，补上一个数
%         sPxx=sqrt(sPxx);
        sPxx = reshape(sPxx,num_imf,num_vol);
%         sPxx = reshape(sPxx,num_vol,num_imf)';
        Pyy = abs(Y).^2;
        sPyy = smooth(Pyy);
%         sPyy=[sPyy;0];
%         sPyy=diff(sPyy);  %数据出现短缺，补上一个数
%         sPyy=sqrt(sPyy);
        sPyy = reshape(sPyy,num_imf,num_vol);
% sPyy = reshape(sPyy,num_vol,num_imf)';
        mol=abs(sPxy.^2);
        den=(sPxx.*sPyy);
        res=mol./den;
%         tmp_coh=[tmp_coh,res];
         tmp_coh(:,:,j,k) = res;%tmp_coh(5,1018,22,22)

        % coherence matrix for the specific pair of ROIs (j and k) at all the frequencies and timepoints
        end
    end
    Coherence{i} = tmp_coh;
%     Phase{i} = tmp_ang;   
end
save([Result_Path, 'Coherence315.mat'],'Coherence','-v7.3');
% save([Result_Path, 'ROIs_Phase.mat'],'Phase','-v7.3');        