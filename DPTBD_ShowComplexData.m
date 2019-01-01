function  DPTBD_ShowComplexData(DataScan)
    n=ndims(DataScan);
    s=size(DataScan);
    figure(randi(100))
    if n == 2
        surf(abs(DataScan));
    else
        PicNum = ceil(sqrt(s(3)));
        for i =1:s(3)
            subplot(PicNum,PicNum,i);
            meshz(abs(DataScan(:,:,i)));
        end
    end
end