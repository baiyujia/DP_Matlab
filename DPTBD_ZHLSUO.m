% DP-TBD for single target tracking %
%假设过程噪声和量测噪声均为0均值高斯白噪声
% 作者：索之玲
% 时间：2018/12/10 
%% clear all
clear 
clc
close all

%% step1 initializatio
F_Cnt = 20;  %帧数
state_cnt = 4;  %状态的个数
%% simulation condition
T_step=1;    % 时间间隔
q_CV = 0.01;
initx = [3 2 3 2]';    %初始状态
x = GenerateStateMetrix(T_step,q_CV, F_Cnt, initx);

%% 产生量测（像素点平面数据）
Power_noise_av = 1;
Theta = 1;
SNR=20;    % 什么用处？
Nx = 50;   %径向距离分辨单元    
Ny = 50;   %切向距离分辨单元
DataScan = DP_GenerateData(x, SNR, Nx, Ny, F_Cnt, Theta , Power_noise_av);
%%

%%数据处理
DataScan_Processed = DP_MainAlgorithm(DataScan);
%%
%%获取轨迹
VT = 150; %门限
TargetTrace = DP_FindTargetTrack(DataScan_Processed,VT);
%%
%%过滤重复的轨迹
RealTrace = DPTBD_FindTrace(TargetTrace,DataScan_Processed);
%%

%%打印轨迹
DPTBD_ShowTrace(RealTrace);
%%
