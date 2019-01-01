function [TargetTraceShow] = DP_TransCell2Mat(TargetTrace)
    %获取维度
    s = size(TargetTrace);
    F_Cnt = s(3);

    %截取最后一帧数据
    for i = 1 : F_Cnt
        FrameValue = cellfun(@(x) x.value, TargetTrace(:,:,i), 'UniformOutput', false);
        TargetTraceShow(:,:,i) = abs(cell2mat(FrameValue));
    end
end