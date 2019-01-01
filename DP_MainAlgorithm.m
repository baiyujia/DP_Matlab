function [ DataScan_Out ] = DP_MainAlgorithm(DataScan,newAlg)
DataScanTmp = DataScan;
%获取维度
s = size(DataScan);
x = s(1);
y = s(2);
F_Cnt = s(3);

DataScan_Out = cell(x, y, F_Cnt);

%信号的迭代处理
for i = 1 : F_Cnt
    for j = 1 : x
        for k = 1 : y
            %第一帧数据，只是把原来的值拷贝过来，没有需要计算的内容
            if i == 1
                Point.lastPoint = [-1, -1];
                Point.value = DataScanTmp(j,k,i);
                DataScan_Out{j,k,i} = Point;
            %第二帧数据简单求最大值
            elseif i == 2
                [MaxValue, lastxPos ,lastyPos] = DP_FindMaxSignalInRange(DataScanTmp(:, :, i - 1),j, k, 16);
                DataScanTmp(j,k,i) = DataScanTmp(j,k,i) + MaxValue;

                Point.lastPoint = [lastxPos, lastyPos];
                Point.value = DataScanTmp(j,k,i);
                DataScan_Out{j,k,i} = Point;
            %第三帧开始，使用cos定理加权计算最大值
            else
                %获得当前位置在上一帧中的最大值的位置：
                [MaxValue, lastxPos ,lastyPos] = DP_FindMaxSignalInRange(DataScanTmp(:, :, i - 1),j, k, 16);
               
                lastlastxPos = DataScan_Out{lastxPos,lastyPos,i-1}.lastPoint(1);
                lastlastyPos = DataScan_Out{lastxPos,lastyPos,i-1}.lastPoint(2);
                if newAlg == 1
                    weight = DP_GetCosWeight(j,k,lastxPos,lastyPos,lastlastxPos,lastlastyPos);
                else
                    weight = 1;
                end
                DataScanTmp(j,k,i) = DataScanTmp(j,k,i) + MaxValue * weight;

                Point.lastPoint = [lastxPos, lastyPos];
                Point.value = DataScanTmp(j,k,i);
                DataScan_Out{j,k,i} = Point;
                
                
                %lastlastxPos = DataScan_Out{lastxPos,lastyPos,i-1}.lastPoint(1);
                %lastlastyPos = DataScan_Out{lastxPos,lastyPos,i-1}.lastPoint(2);
                %weight = DP_GetCosWeight(j,k,lastxPos,lastyPos,lastlastxPos,lastlastyPos);
                %DataScanTmp(j,k,i) = DataScanTmp(j,k,i) + MaxValue * weight;
            end   
            %fprintf('find in %d,%d',xPos ,yPos)
        end
    end
end














