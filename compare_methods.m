close all;
configuration;

numbits = 2048*100;
PN = 40;
bauds = [F_S/8, F_S/16, F_S/4, F_S/16];
UP = length(bauds);

tx = gen_test_sig(input_bits, PN, bauds);

plot_spectrum(tx, F_S*UP);

nfft = 4096;

alpha1 = 0;
alpha2 = F_S/8;
alpha3 = F_S/4;
alpha4 = 3*F_S/8;
alpha5 = F_S/2;
alpha6 = F_S/16;

one_fft    = 10*log(abs(cyclic_spectrum(tx, F_S/8, nfft, F_S*UP, 'one_fft', 10))) ;
freq_shift = 10*log(abs(cyclic_spectrum(tx, F_S/8, nfft, F_S*UP, 'freq_shift', 10))) ;

f = linspace(-F_S/2, F_S/2, nfft);
plot(f, one_fft, 'b-', f, freq_shift, 'k-');

sum(one_fft - freq_shift)
