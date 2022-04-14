%����˵������IMF 5���źŵ�Ƶ����Ϣ���з���
%��Ϊ�����Ƶ��1-4,4-8��8-13,13-30,30-80

close all;
clear;
clc;

%��������Ҫ��IMFs����
Frequency_Path =  'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\';  %���б��Ե�IMFs�ź�λ��
load([Frequency_Path,'AllSubjects_hilbertFrequency.mat']);

%��̬������ֵ
num_roi =22;  %����Ȥ������������ʵ�ʵ���
num_subj=16;  %���Ը��� 
num_vol=1018; %ʱ���������������ݵĴ�С����
num_imf=5;    %��ȡÿ��ROIs�ֽ�ĵ����IMFs�ź�



%��ȡ��IMFs������5��IMFs
imfs_5=cell(num_subj,1);%Ϊimfs���ٿռ�
for i=1:num_subj
    for j=1:num_roi        
        imf_y = Freq{i}{j}(:,num_imf);                            
        imfs_5{i}{j}=imf_y;
    end   
end

%�����ȡ˲ʱƵ�ʲ��Ƚϴ�С���з���
alpha= 0;
beta= 0;
delta= 0;
gamma= 0;
theta= 0;%������ʼ��ֵ
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

%��ͳ��ͼ
 c = [1,2,3,4,5];
 val = [delta,theta,alpha,beta,gamma];
 bar(c,val)
 cd('E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\')
print('Ƶ�ʷֲ�ͼ','-dpng','-r300')