function plot_channels(channels, f_s)
    num_channels = size(channels, 1);
    if num_channels == 2
        factors = [1 2];
    else
        factors = factor(num_channels);
        if length(factors) == 1
            factors = factor(num_channels + 1);
        end
        while length(factors) > 2
            [val, idx] = min(factors);
            factors(idx) = [];
            [o_val, o_idx] = min(factors);
            factors(o_idx)  = val*o_val;
        end
    end

    figure;
    for i=1:num_channels
        subplot(factors(1), factors(2), i);
        plot_spectrum(channels(i, 1:90000), f_s);
    end
end
