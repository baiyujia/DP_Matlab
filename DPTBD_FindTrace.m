function [RealTrace] = DPTBD_FindTrace(TargetTrace,DataScan_Processed)
    rate = 0.7
    %获取维度
    s = size(TargetTrace);
    x = s(1);
    y = s(2);
    Trace_Cnt = s(3);
    RealTrace = [];
    %截取最后一帧数据
    while Trace_Cnt > 0 
        %在所有可能最后一个航迹点上，找出航迹最大的点的坐标
        maxValue = 0

        %将3维降低至二维
        yy = reshape(TargetTrace(end,:,:),y,Trace_Cnt);

        %二维中的每一行数据，就对应这一个坐标点
        index = 1;
        for k = yy
            if abs(maxValue) < abs(DataScan_Processed{k(1),k(2),end}.value)
                maxValue = DataScan_Processed{k(1),k(2),end}.value;
                %记录最大幅值对应的坐标点
                posX =k(1);
                posY = k(2);

                %MaxIndex中存放的是轨迹的编号
                MaxIndex = index;
            end
            index = index+1;
        end

        %把最大航迹取出来，删除原有的航迹组的该条记录
        maxTrace = TargetTrace( :, :, MaxIndex);
        if (length(RealTrace)== 0)
            RealTrace(:,:,1) = maxTrace;
        else
            RealTrace(:,:,end + 1) = maxTrace;
        end
        
        %把当前幅度最大的航迹删除
        TargetTrace( :, :, MaxIndex) = [];
        Trace_Cnt = Trace_Cnt - 1;
        
        %获取与幅值最大航迹相同的航迹的列表，后面统一删除
        dellist = []
        for k = 1 : Trace_Cnt
            %所有的其他航迹和幅值最大的航迹进行比较，如果雷同比率达到rate%，则删除掉
            diffTrace = TargetTrace(1:end-1,:,k) - maxTrace(1:end-1,:);

            %如果当前的轨迹和最大航迹的轨迹相比，有rate%的是相同的，则把该条轨迹删除掉
            if(length(find(diffTrace == 0)) > ((x-1) * y) * rate )
                dellist = [dellist,k]
            end
        end
        %从后向前删除元素，避免删除的过程中，元素移位
        for k = sort(dellist,'descend')
            TargetTrace( :, :, k) = [];
            Trace_Cnt = Trace_Cnt - 1;
        end
    end
    RealTrace
end