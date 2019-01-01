function [ DataScan_Out ] = DP_MainAlgorithm(DataScan,newAlg)
DataScanTmp = DataScan;
%��ȡά��
s = size(DataScan);
x = s(1);
y = s(2);
F_Cnt = s(3);

DataScan_Out = cell(x, y, F_Cnt);

%�źŵĵ�������
for i = 1 : F_Cnt
    for j = 1 : x
        for k = 1 : y
            %��һ֡���ݣ�ֻ�ǰ�ԭ����ֵ����������û����Ҫ���������
            if i == 1
                Point.lastPoint = [-1, -1];
                Point.value = DataScanTmp(j,k,i);
                DataScan_Out{j,k,i} = Point;
            %�ڶ�֡���ݼ������ֵ
            elseif i == 2
                [MaxValue, lastxPos ,lastyPos] = DP_FindMaxSignalInRange(DataScanTmp(:, :, i - 1),j, k, 16);
                DataScanTmp(j,k,i) = DataScanTmp(j,k,i) + MaxValue;

                Point.lastPoint = [lastxPos, lastyPos];
                Point.value = DataScanTmp(j,k,i);
                DataScan_Out{j,k,i} = Point;
            %����֡��ʼ��ʹ��cos�����Ȩ�������ֵ
            else
                %��õ�ǰλ������һ֡�е����ֵ��λ�ã�
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














