%生成数据
function [DataOutput] = DP_GenerateData(Target, snr, ScaleX, ScaleY, F_Cnt, Theta, Power_noise_av)

    Data_target=zeros(ScaleX,ScaleY,F_Cnt);  %每一层有Nx*Ny个数据，共F_Cnt层      
    BGNosie=BackgroundNoise(ScaleX,ScaleY,F_Cnt,Theta);% 背景噪声    每一层有100*100个数据，共10层 独立同分布的零均值复高斯白噪声
    
    Power_target_av=10^(snr/10)*Power_noise_av;  % The average of Target Power.   这个是信噪比的公式  
    
    for t=1:F_Cnt
       IndexX= ceil(Target(1,t));   % ceil函数，朝正无穷大方向取整，值为不小于本身的最小整数    
       IndexY=ceil(Target(3,t));   % 

       Buf  =  Power_target_av*exp(1i*rand(1)*2*pi);  %Yiwei' definition   目标的量测数据  易伟博士论文19页Ak为幅度恒定且相位在0~2π内服从均匀分布的复随机变量
       Data_target(IndexX,IndexY,t) = abs(Buf);
    end  
    
    DataOutput = BGNosie+Data_target;    % 目标幅度与背景噪声组成量测的幅相信息，量测的位置位于分辨单元的中心位置
end
