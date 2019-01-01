% DP-TBD for single target tracking %
%�����������������������Ϊ0��ֵ��˹������
% ���ߣ���֮��
% ʱ�䣺2018/12/10 
%% clear all
clear 
clc
close all

%% step1 initializatio
F_Cnt = 20;  %֡��
state_cnt = 4;  %״̬�ĸ���
%% simulation condition
T_step=1;    % ʱ����
q_CV = 0.01;
initx = [3 2 3 2]';    %��ʼ״̬
x = GenerateStateMetrix(T_step,q_CV, F_Cnt, initx);

%% �������⣨���ص�ƽ�����ݣ�
Power_noise_av = 1;
Theta = 1;
SNR=20;    % ʲô�ô���
Nx = 50;   %�������ֱ浥Ԫ    
Ny = 50;   %�������ֱ浥Ԫ
DataScan = DP_GenerateData(x, SNR, Nx, Ny, F_Cnt, Theta , Power_noise_av);
%%

%%���ݴ���
DataScan_Processed = DP_MainAlgorithm(DataScan);
%%
%%��ȡ�켣
VT = 150; %����
TargetTrace = DP_FindTargetTrack(DataScan_Processed,VT);
%%
%%�����ظ��Ĺ켣
RealTrace = DPTBD_FindTrace(TargetTrace,DataScan_Processed);
%%

%%��ӡ�켣
DPTBD_ShowTrace(RealTrace);
%%
