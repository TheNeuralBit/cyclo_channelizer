function [] = plot_cyc_spec(data, alpha, fft_size, F_S)
    figure;
    %plot(abs(cyclic_spectrum(data, alpha, fft_size, F_S)));
    plot(10*log(abs(cyclic_spectrum(data, alpha, fft_size, F_S))));
    title(sprintf('\\alpha = %d', alpha));
end
