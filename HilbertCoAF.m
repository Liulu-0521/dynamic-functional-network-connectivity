%����˵�����ڶ�ÿһ��IMF����Hilbert�任֮�󣬵õ�IMF�ķ��ȡ���λ��Ƶ��ʱ�������Լ�ϣ�����ؼ�ȨƵ��ֵ
%�������Խ���Щʱ��������ΪROI�������ʱƵ������Է������õ�ROI֮�����ؾ������λ����
close all;
clear;
clc;

%��������Ҫ������
Data_Path= 'E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\';%Hilbert�任�ĵ������н����λ��                        
load([Data_Path,'AllSubjects_hilbert.mat']);%���ؾ���Hilbert�任֮�������
Result_Path='E:\LiuluData\CTF\SourceData\HCP\DMN\ExtractROI\IMFs\HilbertTransform\Network\';
%��̬������ֵ
num_roi =22;  %����Ȥ������������ʵ�ʵ���
num_subj=16;  %���Ը��� 
num_vol=1018; %ʱ���������������ݵĴ�С����
num_imf=5;    %��ȡÿ��ROIs�ֽ��ǰ5��IMFs

Coherence = cell(num_subj,1);   %  ��ɾ���
Phase = cell(num_subj,1);       %  ��λ����

%���㱻��i�ĵ�j������Ȥ�����k������Ȥ����ʱƵ������ԣ�����Ϊ����hilbert�任֮�������
for i = 1:num_subj              % ����������
%     tmp_coh=[];
    for j = 1:num_roi           % ��������Ȥ������
        X=hbt{i}{j};            %������Ȥ����4��IMF����hilber�任֮���4��ʱ��������Ϊһ������ľ���
        for k=1:num_roi
            Y=hbt{i}{k};
             %%%% ����
        Pxy = X.*conj(Y);                                   % X��Y�Ĺ�����ˣ�����������
%         tmp_ang(:,:,j,k) = angle(Pxy)';   %������λ�ǣ���λrad
%       Pxy = zscore(Pxy);                                  % ��Pxy���й�һ����ʹ����Թ��Ʋ�ƫ���ڹ��ʽϴ���źŲ���
        sPxy = smooth(Pxy);                                 % ����ƽ���������������           
        sPxy = reshape(sPxy,num_imf,num_vol);
%          sPxy = reshape(sPxy,num_vol,num_imf)';
  %%% ��ĸ
        Pxx = abs(X).^2;
        sPxx = smooth(Pxx);
%         sPxx=[sPxx;0];
%         sPxx=diff(sPxx);  %���ݳ��ֶ�ȱ������һ����
%         sPxx=sqrt(sPxx);
        sPxx = reshape(sPxx,num_imf,num_vol);
%         sPxx = reshape(sPxx,num_vol,num_imf)';
        Pyy = abs(Y).^2;
        sPyy = smooth(Pyy);
%         sPyy=[sPyy;0];
%         sPyy=diff(sPyy);  %���ݳ��ֶ�ȱ������һ����
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