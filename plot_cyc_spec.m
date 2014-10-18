function [] = plot_cyc_spec(data, alpha, fft_size, F_S, method)
    figure;
    %plot(abs(cyclic_spectrum(data, alpha, fft_size, F_S)));
    plot(10*log(abs(cyclic_spectrum(data, alpha, fft_size, F_S, method))));
    title(sprintf('\\alpha = %d', alpha));
    axis([0 fft_size -80 60]);
end
