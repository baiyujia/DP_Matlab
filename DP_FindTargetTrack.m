function [TargetTrace] = DP_FindTargetTrack(DataScan,VT)
%获取维度
s = size(DataScan);
x = s(1);
y = s(2);
F_Cnt = s(3);

%截取最后一帧数据
LastFrameValue = cellfun(@(x) x.value, DataScan(:,:,F_Cnt), 'UniformOutput', false);

%选择最后一帧数据中大于VT的点的坐标
maxvalue = max(max(abs(cell2mat(LastFrameValue))));
kk=find( abs(cell2mat(LastFrameValue)) ==  maxvalue);

%遍历所有的可能的轨迹点
cnt = 1;
for i = kk';
    [xx,yy] =ind2sub([x,y],i);
    TargetTrace(F_Cnt,:,cnt)= [xx,yy];
    for j =F_Cnt : -1 : 2
        xx = DataScan{xx,yy,j}.lastPoint(1);
        yy = DataScan{xx,yy,j}.lastPoint(2);
        TargetTrace(j-1,:,cnt)= [xx,yy];
    end
    cnt = cnt + 1;
end

end