close all;
default_config;

numbits = 2048*10;
input_bits = randn(1, numbits)<0;
PN = 40;
bauds = [F_S/8, F_S/16, F_S/4, F_S/16];
UP = length(bauds);

tx = gen_test_sig(input_bits, PN, bauds);

plot_spectrum(tx, F_S*UP);

nfft = 1024;

alpha1 = 0;
alpha2 = F_S/16;
alpha3 = F_S/8;
alpha4 = F_S/4;
alpha5 = 3*F_S/8;
alpha6 = F_S/2;

cyc1 = cyclic_spectrum(tx, alpha1, nfft, F_S*UP, CYC_SPEC_METHOD, CYCLO_AVERAGING) ;
cyc2 = cyclic_spectrum(tx, alpha2, nfft, F_S*UP, CYC_SPEC_METHOD, CYCLO_AVERAGING) ;
cyc3 = cyclic_spectrum(tx, alpha3, nfft, F_S*UP, CYC_SPEC_METHOD, CYCLO_AVERAGING) ;
cyc4 = cyclic_spectrum(tx, alpha4, nfft, F_S*UP, CYC_SPEC_METHOD, CYCLO_AVERAGING) ;
cyc5 = cyclic_spectrum(tx, alpha5, nfft, F_S*UP, CYC_SPEC_METHOD, CYCLO_AVERAGING) ;
cyc6 = cyclic_spectrum(tx, alpha6, nfft, F_S*UP, CYC_SPEC_METHOD, CYCLO_AVERAGING) ;

f = linspace(-F_S*UP/2, F_S*UP/2, nfft);

figure;
h1 = axes;
plot3(f, alpha1*ones(1,nfft), 10*log(abs(cyc1)), '-b', ...
      f, alpha2*ones(1,nfft), 10*log(abs(cyc2)), '-b', ...
      f, alpha3*ones(1,nfft), 10*log(abs(cyc3)), '-b', ...
      f, alpha4*ones(1,nfft), 10*log(abs(cyc4)), '-b', ...
      f, alpha5*ones(1,nfft), 10*log(abs(cyc5)), '-b', ...
      f, alpha6*ones(1,nfft), 10*log(abs(cyc6)), '-b');
set(h1, 'Ydir', 'reverse');
    
% TODO use the same FFT for all of these? BECAUSE I CAN
plot_cyc_spec(tx, F_S/16, nfft, F_S*UP, CYC_SPEC_METHOD, CYCLO_AVERAGING);
plot_cyc_spec(tx, F_S/8,  nfft, F_S*UP, CYC_SPEC_METHOD, CYCLO_AVERAGING);
plot_cyc_spec(tx, F_S/4,  nfft, F_S*UP, CYC_SPEC_METHOD, CYCLO_AVERAGING);
plot_cyc_spec(tx, F_S/2,  nfft, F_S*UP, CYC_SPEC_METHOD, CYCLO_AVERAGING);
plot_cyc_spec(tx, F_S,    nfft, F_S*UP, CYC_SPEC_METHOD, CYCLO_AVERAGING);
plot_cyc_spec(tx, 2*F_S,  nfft, F_S*UP, CYC_SPEC_METHOD, CYCLO_AVERAGING);
