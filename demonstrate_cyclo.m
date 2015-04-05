close all;
default_config;

numbits = 2048*10;
input_bits = randn(1, numbits)<0;
PN = 40;
num_chans = 4;
output_f_s = F_S/4;
bauds = [100E3, 156.25E3, 200E3]
UP = length(bauds);

freqs = -F_S/2:output_f_s:F_S/2;
freqs = freqs(1:end-2) + output_f_s;

tx = gen_test_sig(input_bits, PN, bauds, freqs);

plot_spectrum(tx, F_S);

nfft = 2^14
CYC_SPEC_METHOD = 'freq_shift';
for baud=bauds
    plot_cyc_spec(tx, baud, nfft, F_S, CYC_SPEC_METHOD, CYCLO_AVERAGING);
end
