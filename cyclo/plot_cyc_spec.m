function [] = plot_cyc_spec(data, alpha, fft_size, F_S, method, averaging)
    figure;
    %plot(abs(cyclic_spectrum(data, alpha, fft_size, F_S)));
    plot(10*log(abs(cyclic_spectrum(data, alpha, fft_size, F_S, method, averaging))));
    title(sprintf('\\alpha = %d', alpha));
    axis([0 fft_size -40 100]);
end
