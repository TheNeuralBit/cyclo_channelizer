close all;
default_config;

numbits = 2048*10;
input_bits = randn(1, numbits)<0;
PN = 40;
bauds = [F_S/8, F_S/16, F_S/4, F_S/16];
UP = length(bauds);

tx = gen_test_sig(input_bits, PN, bauds);

plot_spectrum(tx, F_S*UP);

threshold = 80;
min_spacing = 2E6;
nfft = 1024;

[freqs, bauds] = cyclo_detect(tx, [F_S/16 F_S/8 F_S/4], threshold, min_spacing, nfft, F_S*4)
