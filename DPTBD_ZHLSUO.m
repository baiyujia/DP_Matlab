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
x = GenerateStateMetrix(T_step,q_CV, F_Cnt, initx)

%% 产生量测（像素点平面数据）
Power_noise_av = 1;
Theta = 1;
SNR=20;    % 什么用处？
Nx = 50;   %径向距离分辨单元    
Ny = 50;   %切向距离分辨单元
DataScan = DP_GenerateData(x, SNR, Nx, Ny, F_Cnt, Theta , Power_noise_av);

%%数据处理
DataScan_Processed = DP_MainAlgorithm(DataScan);

VT = 150; %门限
TargetTrace = DP_FindTargetTrack(DataScan_Processed,VT);

RealTrace = DPTBD_FindTrace(TargetTrace,DataScan_Processed);

n=ndims(RealTrace);
s=size(RealTrace);
if n == 2
    loop = 1;
else
    loop = s(3);
end
loop

coArray=['r','g','c','b','y'];%初始颜色数组
liArray=['o','x','+','*','^'];%初始线条数组

for i =1:loop
    liVal=liArray(1 + rem(i,length(coArray)));%取得随机线条
    coVal=coArray(1 + rem(i,length(coArray)));%取得随机颜色
    plot(RealTrace(:,1,i),RealTrace(:,2,i),[coVal '-' liVal]);
    hold on
end

function [x] = GenerateStateMetrix(T_step,q_CV, F_Cnt, initx)
    F = [1 T_step 0 0 ; 
         0 1      0 0 ; 
         0 0      1 T_step ;
         0 0      0 1]; % 目标状态转移矩阵 匀速运动

    Q_CV=[T_step^3/3 T_step^2/2 0 0;
          T_step^2/2 T_step     0 0;        % 过程噪声方差矩阵   具体的求法？
          0             0      T_step^3/3 T_step^2/2;
          0             0      T_step^2/2 T_step];

    Q=Q_CV*diag([q_CV q_CV q_CV q_CV]);     % 为什么这么求？

    processNoise =sample_gaussian(zeros(length(Q),1),Q,F_Cnt);% Note ' here! state_noise_samples is: ss-Total_time 5行10列的噪声  

    x(:,1) = initx;                          % Initial state.%  真实的状态 

    for t=2 : F_Cnt
      %x(:,t)=F*x(:,t-1)+processNoise(:,t);  % For CV Model. 匀速行驶的真实的状态
      x(:,t)=F*x(:,t-1);
    end
end
%生成数据
function [DataOutput] = DP_GenerateData(Target, snr, ScaleX, ScaleY, F_Cnt, Theta, Power_noise_av)

    Data_target=zeros(ScaleX,ScaleY,F_Cnt);  %每一层有Nx*Ny个数据，共F_Cnt层      
    BGNosie=BackgroundNoise(ScaleX,ScaleY,F_Cnt,Theta);% 背景噪声    每一层有100*100个数据，共10层 独立同分布的零均值复高斯白噪声
    
    Power_target_av=10^(snr/10)*Power_noise_av;  % The average of Target Power.   这个是信噪比的公式  
    
    for t=1:F_Cnt
       IndexX= ceil(Target(1,t));   % ceil函数，朝正无穷大方向取整，值为不小于本身的最小整数    
       IndexY=ceil(Target(3,t));   % 

       Buf  =  Power_target_av*exp(1i*rand(1)*2*pi);  %Yiwei' definition   目标的量测数据  易伟博士论文19页Ak为幅度恒定且相位在0~2π内服从均匀分布的复随机变量
       Data_target(IndexX,IndexY,t) = Buf;
    end  
    
    DataOutput = BGNosie+Data_target;    % 目标幅度与背景噪声组成量测的幅相信息，量测的位置位于分辨单元的中心位置
end

