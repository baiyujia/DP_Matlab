function [ z ] = BackgroundNoise(x,y,total,Theta)
% bring out Nx*Ny*K dimension complex background noise
% Nx:  
% Ny:
%  K:

z=zeros(x,y,total);
for i=1:total
Buf=randn(x,y);
BufMean=mean(mean(Buf));
BufCov=cov(Buf(:));
OneFrame=(Buf-BufMean)./BufCov*Theta;
z(:,:,i)=OneFrame;
end

for i=1:total
Buf=randn(x,y);
BufMean=mean(mean(Buf));
BufCov=cov(Buf(:));
OneFrame=(Buf-BufMean)./BufCov*Theta;
z(:,:,i)=z(:,:,i)+1i*OneFrame;
end

end

