function [RealTrace] = DPTBD_FindTrace(TargetTrace,DataScan_Processed)
    rate = 0.7
    %��ȡά��
    s = size(TargetTrace);
    x = s(1);
    y = s(2);
    Trace_Cnt = s(3);
    RealTrace = [];
    %��ȡ���һ֡����
    while Trace_Cnt > 0 
        %�����п������һ���������ϣ��ҳ��������ĵ������
        maxValue = 0

        %��3ά��������ά
        yy = reshape(TargetTrace(end,:,:),y,Trace_Cnt);

        %��ά�е�ÿһ�����ݣ��Ͷ�Ӧ��һ�������
        index = 1;
        for k = yy
            if abs(maxValue) < abs(DataScan_Processed{k(1),k(2),end}.value)
                maxValue = DataScan_Processed{k(1),k(2),end}.value;
                %��¼����ֵ��Ӧ�������
                posX =k(1);
                posY = k(2);

                %MaxIndex�д�ŵ��ǹ켣�ı��
                MaxIndex = index;
            end
            index = index+1;
        end

        %����󺽼�ȡ������ɾ��ԭ�еĺ�����ĸ�����¼
        maxTrace = TargetTrace( :, :, MaxIndex);
        if (length(RealTrace)== 0)
            RealTrace(:,:,1) = maxTrace;
        else
            RealTrace(:,:,end + 1) = maxTrace;
        end
        
        %�ѵ�ǰ�������ĺ���ɾ��
        TargetTrace( :, :, MaxIndex) = [];
        Trace_Cnt = Trace_Cnt - 1;
        
        %��ȡ���ֵ��󺽼���ͬ�ĺ������б�����ͳһɾ��
        dellist = []
        for k = 1 : Trace_Cnt
            %���е����������ͷ�ֵ���ĺ������бȽϣ������ͬ���ʴﵽrate%����ɾ����
            diffTrace = TargetTrace(1:end-1,:,k) - maxTrace(1:end-1,:);

            %�����ǰ�Ĺ켣����󺽼��Ĺ켣��ȣ���rate%������ͬ�ģ���Ѹ����켣ɾ����
            if(length(find(diffTrace == 0)) > ((x-1) * y) * rate )
                dellist = [dellist,k]
            end
        end
        %�Ӻ���ǰɾ��Ԫ�أ�����ɾ���Ĺ����У�Ԫ����λ
        for k = sort(dellist,'descend')
            TargetTrace( :, :, k) = [];
            Trace_Cnt = Trace_Cnt - 1;
        end
    end
    RealTrace
end