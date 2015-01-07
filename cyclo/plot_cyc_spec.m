function [] = plot_cyc_spec(data, alpha, fft_size, F_S, method, averaging)
    figure;
    %plot(abs(cyclic_spectrum(data, alpha, fft_size, F_S)));
    plot(linspace(-F_S/2, F_S/2, fft_size), ...
         10*log(abs(cyclic_spectrum(data, alpha, fft_size, F_S, method, averaging))));
    title(sprintf('SCD at \\alpha = %d', alpha));
    axis([-F_S/2 F_S/2 -40 100]);
    xlabel('Frequency (Hz)')
    ylabel('S_{xx}(\alpha, f) (dB)')
end
