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
VT = 150; %����

Nx = 50;   %�������ֱ浥Ԫ    
Ny = 50;   %�������ֱ浥Ԫ

DeltaX = 1; 
DeltaY = 1;   %ʵ��λ��ӳ�䵽�����µ�ת��ϵ��

initx = [3 2 3 2]';    %��ʼ״̬
initx2 = [5 2 Nx-5 -2]';    %��ʼ״̬
q_CV=0.01;   % ���������������������ܶ�   ��ʲô��˼��
%% simulation condition
T_step=1;    % ʱ����
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

x2(:,1) = initx2;                          % Initial state.%  ��ʵ��״̬ 
  
for t=2 : F_Cnt
  %x(:,t)=F*x(:,t-1)+processNoise(:,t);  % For CV Model. ������ʻ����ʵ��״̬
  x2(:,t)=F*x2(:,t-1);
end


%% �������⣨���ص�ƽ�����ݣ�
Theta=1;   % ������������
BGNosie=BackgroundNoise(Nx,Ny,F_Cnt,Theta);% ��������    ÿһ����100*100�����ݣ���10�� ����ͬ�ֲ������ֵ����˹������

Data_target=zeros(Nx,Ny,F_Cnt);  %ÿһ����Nx*Ny�����ݣ���F_Cnt��  
  
SNR=10;    % ʲô�ô���
Power_noise_av=1;   % �źŹ���
Power_target_av=10^(SNR/10)*Power_noise_av;  % The average of Target Power.   ���������ȵĹ�ʽ  
for t=1:F_Cnt
   IndexX= ceil(x(1,t)/DeltaX);   % ceil�����������������ȡ����ֵΪ��С�ڱ������С����    
   IndexY=ceil(x(3,t)/DeltaY);   % 
 
  Buf  =  Power_target_av*exp(1i*rand(1)*2*pi);  %Yiwei' definition   Ŀ�����������  ��ΰ��ʿ����19ҳAkΪ���Ⱥ㶨����λ��0~2���ڷ��Ӿ��ȷֲ��ĸ��������
  Data_target(IndexX,IndexY,t) = 10;%Buf;
  
   IndexX= ceil(x2(1,t)/DeltaX);   % ceil�����������������ȡ����ֵΪ��С�ڱ������С����    
   IndexY=ceil(x2(3,t)/DeltaY);   % 
 
  Buf  =  Power_target_av*exp(1i*rand(1)*2*pi);  %Yiwei' definition   Ŀ�����������  ��ΰ��ʿ����19ҳAkΪ���Ⱥ㶨����λ��0~2���ڷ��Ӿ��ȷֲ��ĸ��������
  Data_target(IndexX,IndexY,t) = 10;%Buf;
end  
DataScan=BGNosie+Data_target;    % Ŀ������뱳�������������ķ�����Ϣ�������λ��λ�ڷֱ浥Ԫ������λ��
%DataScan=Data_target;
%��ԭʼ��3��������ͼ
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

coArray=['r','g','c','b','y'];%��ʼ��ɫ����
liArray=['o','x','+','*','^'];%��ʼ��������

subplot(3,1,3)
for i =1:loop
    liVal=liArray(rem(i,length(coArray)));%ȡ���������
    coVal=coArray(rem(i,length(coArray)));%ȡ�������ɫ
    plot(RealTrace(:,1,i),RealTrace(:,2,i),[coVal '-' liVal]);
    hold on
end