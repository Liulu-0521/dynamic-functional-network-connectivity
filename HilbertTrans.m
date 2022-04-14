%���ݳ���CoIMFsSignal�ķ������Եõ���ROIs�ֽ�õ���IMFs�У�ǰ5��IMFs��Դ�ź��������ǿ
%������ȡÿ��ROI��ǰ5��IMFs����Hilbert�任
%�������IMF����Hilbert�任���ڸ���ʱ����˲ʱ���ȣ���λ��Ƶ��
close all;
clear;
clc;

%��������Ҫ��IMFs����
IMFs_Path =  'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\';  %���б��Ե�IMFs�ź�λ��
Hilbert_Path= 'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\';%Hilbert�任�ĵ������н����λ��                        
load([IMFs_Path,'AllSubjects_imf.mat']);

%��̬������ֵ
num_roi =22;  %����Ȥ������������ʵ�ʵ���
num_subj=16;  %���Ը��� 
num_vol=1018; %ʱ���������������ݵĴ�С����
num_imf=5;    %��ȡÿ��ROIs�ֽ��ǰ4��IMFs
ts = 1/500;   %�����ݵ��ʱ����


%�����IMFs������Hilbert�任
hbt=cell(num_subj,1);%Ϊimfs����hilbert�任���ٿռ�
for i=1:num_subj
    for j=1:num_roi        
        imf_x = imf{i}{j}(:,1:num_imf);                         % ��ȡǰnum_imf(Ҳ����ǰ4)����ʱ�����*imf��           
        hbt{i}{j} = hilbert(imf_x);                         % ϣ�����ر任�����źŴ�ʱ��任��ʱƵ�򣻻�ȡimf_x�Ľ����ź�                   
    end   
end
save( [Hilbert_Path,'AllSubjects','_hilbert.mat'],'hbt')   

%�����IMF���ڸ���ʱ����ϵ�˲ʱ���ȡ���λ��Ƶ��
%˲ʱ����Amp��˲ʱ��λPha��˲ʱƵ��Freq
Amp=cell(num_subj,1);
for i=1:num_subj
    for j=1:num_roi        
        imf_x = imf{i}{j}(:,1:num_imf);                         % ��ȡǰnum_imf(Ҳ����ǰ4)����ʱ�����*imf��           
        for k=1:num_imf
            for m=1:num_vol
                Amp{i}{j}(m,k) = abs(hbt{i}{j}(m,k));  %����IMFs˲ʱ����ֵ                                    
            end
        end 
    end
end
save( [Hilbert_Path,'AllSubjects','_hilbertAmplitude.mat'],'Amp')   %����IMFs�����˲ʱ����

Pha=cell(num_subj,1);
for i=1:num_subj
    for j=1:num_roi        
        imf_x = imf{i}{j}(:,1:num_imf);                         % ��ȡǰnum_imf(Ҳ����ǰ4)����ʱ�����*imf��           
        for k=1:num_imf
            for m=1:num_vol
                Pha{i}{j}(m,k) = angle((hbt{i}{j}(m,k)));  %����IMFs˲ʱ��λ����λΪrad����Χ+-��֮��                                     
            end
        end 
    end
end
save( [Hilbert_Path,'AllSubjects','_hilbertPhase.mat'],'Pha')   


Freq=cell(num_subj,1);
for i=1:num_subj
    for j=1:num_roi        
        for k=1:num_imf
            Q(:,k)=unwrap(Pha{i}{j}(:,k));%��ʱ�洢��λ��������
            Freq{i}{j}(:,k) = gradient(Q(:,k),ts);% ʹ����Ǽ���˲ʱ��Ƶ��              
        end 
    end
end
save( [Hilbert_Path,'AllSubjects','_hilbertFrequency.mat'],'Freq')   


%����˲ʱƵ�ʵ�ϣ�����ؼ�ȨƵ��HWF
HWF=cell(num_subj,1);
for i=1:num_subj
    for j=1:num_roi        
        for k=1:num_imf
            mol=0;
            den=0;
           for m=1:num_vol
               mol=mol+((Freq{i}{j}(m,k))*(( Amp{i}{j}(m,k))^2));%����
               den=den+(( Amp{i}{j}(m,k))^2);%��ĸ  
           end
            HWF{i}{j}(k)=mol/den;
        end 
    end
end
save( [Hilbert_Path,'AllSubjects','_hilbertHWF.mat'],'HWF')   

%����˲ʱ���ȣ���������ϣ�����ؼ�Ȩƽ��Ƶ��HWMF
HWMF=cell(num_subj,1);
absolu=cell(num_subj,1);
for i=1:num_subj
    for j=1:num_roi        
        for k=1:num_imf
            mol=0;%����
            den=0;%��ĸ
            absol=0;%����
           for m=1:num_vol
               absol=absol+abs(Amp{i}{j}(m,k));%����
              
           end
            absolu{i}{j}(k)=absol;
            mol=mol+absolu{i}{j}(k)*HWF{i}{j}(k);
            den=den+absolu{i}{j}(k);
          
        end 
          HWMF{i}{j}=mol/den;
    end
end
save( [Hilbert_Path,'AllSubjects','_hilbertHWMF.mat'],'HWMF')   