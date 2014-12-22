function [cyc_spec] = single_fft_cyclo(f_data, alpha, F_S)
    fft_size = size(f_data, 1);
    num_bins = alpha/2.0/(F_S/fft_size);
    if floor(num_bins) ~= num_bins
        disp('WARNING: non integer number of bins required.')
        disp('Suggest changing FFT size or using frequency shift method.')
        num_bins = round(num_bins);
    end
    s_right = circshift(f_data, [num_bins, 0]);
    s_left = circshift(f_data, [-num_bins, 0]);
    cyc_spec = mean(s_right.*conj(s_left), 2);
end
