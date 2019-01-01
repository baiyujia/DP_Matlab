%��������
function [DataOutput] = DP_GenerateData(Target, snr, ScaleX, ScaleY, F_Cnt, Theta, Power_noise_av)

    Data_target=zeros(ScaleX,ScaleY,F_Cnt);  %ÿһ����Nx*Ny�����ݣ���F_Cnt��      
    BGNosie=BackgroundNoise(ScaleX,ScaleY,F_Cnt,Theta);% ��������    ÿһ����100*100�����ݣ���10�� ����ͬ�ֲ������ֵ����˹������
    
    Power_target_av=10^(snr/10)*Power_noise_av;  % The average of Target Power.   ���������ȵĹ�ʽ  
    
    for t=1:F_Cnt
       IndexX= ceil(Target(1,t));   % ceil�����������������ȡ����ֵΪ��С�ڱ������С����    
       IndexY=ceil(Target(3,t));   % 

       Buf  =  Power_target_av*exp(1i*rand(1)*2*pi);  %Yiwei' definition   Ŀ�����������  ��ΰ��ʿ����19ҳAkΪ���Ⱥ㶨����λ��0~2���ڷ��Ӿ��ȷֲ��ĸ��������
       Data_target(IndexX,IndexY,t) = abs(Buf);
    end  
    
    DataOutput = BGNosie+Data_target;    % Ŀ������뱳�������������ķ�����Ϣ�������λ��λ�ڷֱ浥Ԫ������λ��
end
