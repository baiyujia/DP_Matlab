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
x = GenerateStateMetrix(T_step,q_CV, F_Cnt, initx)

%% �������⣨���ص�ƽ�����ݣ�
Power_noise_av = 1;
Theta = 1;
SNR=20;    % ʲô�ô���
Nx = 50;   %�������ֱ浥Ԫ    
Ny = 50;   %�������ֱ浥Ԫ
DataScan = DP_GenerateData(x, SNR, Nx, Ny, F_Cnt, Theta , Power_noise_av);

%%���ݴ���
DataScan_Processed = DP_MainAlgorithm(DataScan);

VT = 150; %����
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

coArray=['r','g','c','b','y'];%��ʼ��ɫ����
liArray=['o','x','+','*','^'];%��ʼ��������

for i =1:loop
    liVal=liArray(1 + rem(i,length(coArray)));%ȡ���������
    coVal=coArray(1 + rem(i,length(coArray)));%ȡ�������ɫ
    plot(RealTrace(:,1,i),RealTrace(:,2,i),[coVal '-' liVal]);
    hold on
end

function [x] = GenerateStateMetrix(T_step,q_CV, F_Cnt, initx)
    F = [1 T_step 0 0 ; 
         0 1      0 0 ; 
         0 0      1 T_step ;
         0 0      0 1]; % Ŀ��״̬ת�ƾ��� �����˶�

    Q_CV=[T_step^3/3 T_step^2/2 0 0;
          T_step^2/2 T_step     0 0;        % ���������������   ������󷨣�
          0             0      T_step^3/3 T_step^2/2;
          0             0      T_step^2/2 T_step];

    Q=Q_CV*diag([q_CV q_CV q_CV q_CV]);     % Ϊʲô��ô��

    processNoise =sample_gaussian(zeros(length(Q),1),Q,F_Cnt);% Note ' here! state_noise_samples is: ss-Total_time 5��10�е�����  

    x(:,1) = initx;                          % Initial state.%  ��ʵ��״̬ 

    for t=2 : F_Cnt
      %x(:,t)=F*x(:,t-1)+processNoise(:,t);  % For CV Model. ������ʻ����ʵ��״̬
      x(:,t)=F*x(:,t-1);
    end
end
%��������
function [DataOutput] = DP_GenerateData(Target, snr, ScaleX, ScaleY, F_Cnt, Theta, Power_noise_av)

    Data_target=zeros(ScaleX,ScaleY,F_Cnt);  %ÿһ����Nx*Ny�����ݣ���F_Cnt��      
    BGNosie=BackgroundNoise(ScaleX,ScaleY,F_Cnt,Theta);% ��������    ÿһ����100*100�����ݣ���10�� ����ͬ�ֲ������ֵ����˹������
    
    Power_target_av=10^(snr/10)*Power_noise_av;  % The average of Target Power.   ���������ȵĹ�ʽ  
    
    for t=1:F_Cnt
       IndexX= ceil(Target(1,t));   % ceil�����������������ȡ����ֵΪ��С�ڱ������С����    
       IndexY=ceil(Target(3,t));   % 

       Buf  =  Power_target_av*exp(1i*rand(1)*2*pi);  %Yiwei' definition   Ŀ�����������  ��ΰ��ʿ����19ҳAkΪ���Ⱥ㶨����λ��0~2���ڷ��Ӿ��ȷֲ��ĸ��������
       Data_target(IndexX,IndexY,t) = Buf;
    end  
    
    DataOutput = BGNosie+Data_target;    % Ŀ������뱳�������������ķ�����Ϣ�������λ��λ�ڷֱ浥Ԫ������λ��
end

