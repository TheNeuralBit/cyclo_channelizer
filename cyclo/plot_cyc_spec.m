function [] = plot_cyc_spec(data, alpha, fft_size, F_S, method, averaging)
    figure;
    %plot(abs(cyclic_spectrum(data, alpha, fft_size, F_S)));
    scd = cyclic_spectrum(data, alpha, fft_size, F_S, method, averaging);
    plot(linspace(-F_S/2, F_S/2, fft_size), ...
         10*log(abs(scd(:, 1))));
    title(sprintf('SCD at \\alpha = %d', alpha));
    axis([-F_S/2 F_S/2 -40 100]);
    xlabel('Frequency (Hz)')
    ylabel('S_{xx}(\alpha, f) (dB)')
end
