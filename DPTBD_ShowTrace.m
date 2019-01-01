function  DPTBD_ShowTrace(RealTrace)
    n=ndims(RealTrace);
    s=size(RealTrace);
    if n == 2
        loop = 1;
    else
        loop = s(3);
    end
    loop

    coArray=['r','g','c','b','y'];%初始颜色数组
    liArray=['o','x','+','*','^'];%初始线条数组
    figure(33)
    for i =1:loop
        liVal=liArray(1 + rem(i,length(coArray)));%取得随机线条
        coVal=coArray(1 + rem(i,length(coArray)));%取得随机颜色
        plot(RealTrace(:,1,i),RealTrace(:,2,i),[coVal '-' liVal]);
        hold on
    end
end