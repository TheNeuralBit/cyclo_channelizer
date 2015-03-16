function [partition_b] = partition_filter(b, M, D)

    b = [b zeros(1, M - (mod(length(b) - 1, M) + 1))];
    b = reshape(b, M, []);
    b = upsample(b.', 2).';

    lower_b = [zeros(M/2, 1) b(M/2+1:M, :)];
    partition_b = vertcat(num2cell(b(1:M/2,:), 2), num2cell(lower_b, 2));
end
