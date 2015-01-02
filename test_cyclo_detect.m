close all;
default_config;

numbits = 2048*10;
input_bits = randn(1, numbits)<0;
PN = 40;
bauds = [1/8, 1/16, 1/4, 1/16].*F_S./4;
freqs = (-(length(bauds) - 1)/2:(length(bauds) - 1)/2).*(F_S/(length(bauds) + 1));

tx = gen_test_sig(input_bits, PN, bauds, freqs);

plot_spectrum(tx, F_S);

threshold = 80;
min_spacing = F_S/length(bauds)/2;
nfft = 1024;

bauds_to_check = sort(unique(bauds));
[freqs, bauds] = cyclo_detect(tx, bauds_to_check, threshold, min_spacing, nfft, F_S)
