
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
