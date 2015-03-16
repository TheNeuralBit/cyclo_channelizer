function [partition_b] = partition_filter(b, M, D)
    extra_zeros = M - (mod(length(b) - 1, M) + 1);
    b = [b zeros(1, extra_zeros)];
    b = reshape(b, M, []);
    b = upsample(b.', 2).';
    b = b(:,1:end-1); % Trim off the trailing zero

    lower_b = [zeros(M/2, 1) b(M/2+1:M, :)];
    partition_b = vertcat(num2cell(b(1:M/2,:), 2), num2cell(lower_b, 2));
    partition_b{end} = partition_b{end}(1:end-extra_zeros);
end
