function [TargetTraceShow] = DP_TransCell2Mat(TargetTrace)
    %��ȡά��
    s = size(TargetTrace);
    F_Cnt = s(3);

    %��ȡ���һ֡����
    for i = 1 : F_Cnt
        FrameValue = cellfun(@(x) x.value, TargetTrace(:,:,i), 'UniformOutput', false);
        TargetTraceShow(:,:,i) = abs(cell2mat(FrameValue));
    end
end