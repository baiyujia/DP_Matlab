function [ DataScan_Out ] = DP_MainAlgorithm(DataScan)
DataScanTmp = DataScan;
%获取维度
s = size(DataScan);
x = s(1);
y = s(2);
F_Cnt = s(3);

DataScan_Out = cell(x, y, F_Cnt);

%信号的迭代处理
for i = 2 : F_Cnt
    for j = 1 : x
        for k = 1 : y
            %第二桢数据按照之前的方法进行
            if 1
                [MaxValue, lastxPos ,lastyPos] = DP_FindMaxSignalInRange(DataScanTmp(:, :, i - 1),j, k, 16);
                DataScanTmp(j,k,i) = DataScanTmp(j,k,i) + MaxValue;

                Point.lastPoint = [lastxPos, lastyPos];
                Point.value = DataScanTmp(j,k,i);
                DataScan_Out{j,k,i} = Point;
            else
                %获得当前位置在上一帧中的最大值的位置：
                [MaxValue, lastxPos ,lastyPos] = DP_FindMaxSignalInRange(DataScanTmp(:, :, i - 1),j, k, 16);
                
                Point.lastPoint = [lastxPos, lastyPos];
                Point.value = DataScanTmp(j,k,i);
                DataScan_Out{j,k,i} = Point;
                
                lastlastxPos = DataScan_Out{lastxPos,lastyPos,i-1}.lastPoint(1);
                lastlastyPos = DataScan_Out{lastxPos,lastyPos,i-1}.lastPoint(2);
                weight = DP_GetCosWeight(j,k,lastxPos,lastyPos,lastlastxPos,lastlastyPos);
                DataScanTmp(j,k,i) = DataScanTmp(j,k,i) + MaxValue * weight;
            end   
            %fprintf('find in %d,%d',xPos ,yPos)
        end
    end
end














