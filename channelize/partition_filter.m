function [partition_b] = partition_filter(b, M, D)
    partition_b = cell(M, 1);
    for i = 1:M/2
        partition_b{i} = upsample(b(i:M:end), 2);
    end
    for i = M/2+1:M
        partition_b{i} = [0 upsample(b(i:M:end), 2)];
    end
end
