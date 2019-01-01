function [ MaxValue,xPos, yPos ] = DP_FindMaxSignalInRange(DataScan, InputX, InputY, Range)
MaxValue = 0;
xPos = 0;
yPos = 0;
%获取维度
s=size(DataScan);
x =s(1);
y = s(2);

l = ceil((sqrt(Range) - 1) / 2);

%信号的迭代处理
for i = -l : l
    for j = -l : l
        if (InputX + i < 1) || (InputY + j < 1) || (InputX + i > x) || (InputY + j > y)
            continue;
        end
        
        if abs(MaxValue) < abs(DataScan(InputX + i, InputY + j))
            MaxValue = DataScan(InputX + i, InputY + j);
            xPos = InputX + i;
            yPos = InputY + j;
        end
    end
end
end