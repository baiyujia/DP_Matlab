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
VT = 150; %门限

Nx = 50;   %径向距离分辨单元    
Ny = 50;   %切向距离分辨单元

DeltaX = 1; 
DeltaY = 1;   %实际位置映射到坐标下的转换系数

initx = [3 2 3 2]';    %初始状态
initx2 = [5 2 Nx-5 -2]';    %初始状态
q_CV=0.01;   % 连续过程噪声的能量谱密度   是什么意思？
%% simulation condition
T_step=1;    % 时间间隔
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

x2(:,1) = initx2;                          % Initial state.%  真实的状态 
  
for t=2 : F_Cnt
  %x(:,t)=F*x(:,t-1)+processNoise(:,t);  % For CV Model. 匀速行驶的真实的状态
  x2(:,t)=F*x2(:,t-1);
end


%% 产生量测（像素点平面数据）
Theta=1;   % 背景噪声方差
BGNosie=BackgroundNoise(Nx,Ny,F_Cnt,Theta);% 背景噪声    每一层有100*100个数据，共10层 独立同分布的零均值复高斯白噪声

Data_target=zeros(Nx,Ny,F_Cnt);  %每一层有Nx*Ny个数据，共F_Cnt层  
  
SNR=10;    % 什么用处？
Power_noise_av=1;   % 信号功率
Power_target_av=10^(SNR/10)*Power_noise_av;  % The average of Target Power.   这个是信噪比的公式  
for t=1:F_Cnt
   IndexX= ceil(x(1,t)/DeltaX);   % ceil函数，朝正无穷大方向取整，值为不小于本身的最小整数    
   IndexY=ceil(x(3,t)/DeltaY);   % 
 
  Buf  =  Power_target_av*exp(1i*rand(1)*2*pi);  %Yiwei' definition   目标的量测数据  易伟博士论文19页Ak为幅度恒定且相位在0~2π内服从均匀分布的复随机变量
  Data_target(IndexX,IndexY,t) = 10;%Buf;
  
   IndexX= ceil(x2(1,t)/DeltaX);   % ceil函数，朝正无穷大方向取整，值为不小于本身的最小整数    
   IndexY=ceil(x2(3,t)/DeltaY);   % 
 
  Buf  =  Power_target_av*exp(1i*rand(1)*2*pi);  %Yiwei' definition   目标的量测数据  易伟博士论文19页Ak为幅度恒定且相位在0~2π内服从均匀分布的复随机变量
  Data_target(IndexX,IndexY,t) = 10;%Buf;
end  
DataScan=BGNosie+Data_target;    % 目标幅度与背景噪声组成量测的幅相信息，量测的位置位于分辨单元的中心位置
%DataScan=Data_target;
%对原始的3桢数据作图
DataScan_Processed = DP_MainAlgorithm(DataScan);
figure(2)
subplot(3,1,1)
mesh(abs(sum(DataScan,3)))
subplot(3,1,2)
plot(x(1,:),x(3,:),'r-o')
hold on
plot(x2(1,:),x2(3,:),'g-^')

TargetTrace = DP_FindTargetTrack(DataScan_Processed,VT);

RealTrace = DPTBD_FindTrace(TargetTrace,DataScan_Processed)

n=ndims(RealTrace);
s=size(RealTrace);
if n == 2
    loop = 1
else
    loop = s(3)
end

coArray=['r','g','c','b','y'];%初始颜色数组
liArray=['o','x','+','*','^'];%初始线条数组

subplot(3,1,3)
for i =1:loop
    liVal=liArray(rem(i,length(coArray)));%取得随机线条
    coVal=coArray(rem(i,length(coArray)));%取得随机颜色
    plot(RealTrace(:,1,i),RealTrace(:,2,i),[coVal '-' liVal]);
    hold on
end