function  DPTBD_ShowTrace(RealTrace)
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
    figure(33)
    for i =1:loop
        liVal=liArray(1 + rem(i,length(coArray)));%ȡ���������
        coVal=coArray(1 + rem(i,length(coArray)));%ȡ�������ɫ
        plot(RealTrace(:,1,i),RealTrace(:,2,i),[coVal '-' liVal]);
        hold on
    end
end