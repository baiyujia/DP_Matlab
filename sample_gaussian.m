function [Gaussian] = sample_gaussian(X,Q,N)
%SAMPLE_GAUSSIAN bring out Gaussian independent data
%  X;  mean value of the state
%  Q:  covariance 
%  N:  step number

R = sqrt(Q);
StateSize=length(X);
Noise=randn(StateSize,N);
Noise_Gaussian=zeros(1,N);
for h=1:StateSize
    Noise_mean=mean(Noise(h,:));
    Noise_std=std(Noise(h,:));
    Noise_Gaussian(h,:)=(Noise(h,:)-Noise_mean)/Noise_std;
end
Gaussian= repmat(X,1,N) + R*Noise_Gaussian;

end

