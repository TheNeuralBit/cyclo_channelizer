function [data_fft, P, V] = os_fft(data, decimations, fft_size)
    dec_lcm = lcms(decimations);
    %dec_lcm = 32;
    
    output = cell(length(decimations), 1);
    
    longest_filt = design_filter(max(decimations));
    P = length(longest_filt);
    
    % TODO: allow frequency shifting in EITHER time or frequency
    % If we are frequency shifting in the time domain then
    % we only need to ensure that P is a multiple of the decimation
    %P = P + dec_lcm - (mod((P - 1) - 1, dec_lcm) + 1);
    
    % If shifting in the frequency domain we need to be a little more
    % ensure that V is an integer
    P = ldf(P-1, fft_size) + 1;
    
    V = round(fft_size/(P - 1));
    
    % Compute FFT
    data_fft = fft(buffer(data, fft_size, (P - 1)), [], 1);
end

function [rtrn] = ldf(k, n)
    % ldf returns the lowest divisor of n that is greater than k
    if mod(n, k) == 0
        rtrn = k;
    elseif 2*k > n
        rtrn = n;
    else
        rtrn = ldf(k+1, n);
    end
end
