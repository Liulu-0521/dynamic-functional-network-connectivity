%函数说明：对IMF 5的信号的频率信息进行分类
%分为五个段频段1-4,4-8，8-13,13-30,30-80

close all;
clear;
clc;

%加载所需要的IMFs数据
Frequency_Path =  'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\';  %所有被试的IMFs信号位置
load([Frequency_Path,'AllSubjects_hilbertFrequency.mat']);

%静态变量赋值
num_roi =22;  %感兴趣区个数，根据实际调整
num_subj=16;  %被试个数 
num_vol=1018; %时间点个数，根据数据的大小决定
num_imf=5;    %提取每个ROIs分解的第五个IMFs信号



%提取各IMFs分量第5个IMFs
imfs_5=cell(num_subj,1);%为imfs开辟空间
for i=1:num_subj
    for j=1:num_roi        
        imf_y = Freq{i}{j}(:,num_imf);                            
        imfs_5{i}{j}=imf_y;
    end   
end

%逐个获取瞬时频率并比较大小进行分类
alpha= 0;
beta= 0;
delta= 0;
gamma= 0;
theta= 0;%计数初始赋值
imf_y=[];
for i=1:num_subj
    for j=1:num_roi 
        for k=1:num_vol
        imf_y = imfs_5{i}{j}(k);                            
        if (1<=imf_y&&imf_y<4)
            delta=delta+1;
        else
            if (4<=imf_y&&imf_y<8)
                theta=theta+1;
            else
                if (8<=imf_y&&imf_y<13)
                    alpha=alpha+1;
                else
                    if(13<=imf_y&&imf_y<30)
                        beta=beta+1;
                    else
                        if((30<=imf_y)&&(imf_y<80))
                            gamma=gamma+1;
                        end
                    end
                end
            end
        end
        
        end
    end   
end

%画统计图
 c = [1,2,3,4,5];
 val = [delta,theta,alpha,beta,gamma];
 bar(c,val)
 cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\')
print('频率分布图','-dpng','-r300')