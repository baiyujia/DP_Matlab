
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
