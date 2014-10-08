close all;
configuration;

numbits = 2048*100;
input_bits = randn(1, numbits)<0;
PN = 20;
UP = 4;

% Compute Noise variance based on desired noise power
% pretty sure this is wrong
noise_variance = 10.^(0.1*PN)/(F_S*UP*2);

%% Run the Transmitter
%tx = MyTransmitter(input_bits);
% Generate channel 1 at baud rate fs/4
chan1 = simple_tx(input_bits(1:length(input_bits)/4), 'QPSK', 16, F_S, .25);
% Generate channel 2 at baud rate fs/8
chan2 = simple_tx(input_bits(1:length(input_bits)/2), 'QPSK', 8, F_S, .25);
 
% upsample data
Hd=design(fdesign.lowpass('Fp,Fst',3/4/UP, 1/UP), 'equiripple');

chan1_up = upsample(chan1, UP);
chan1_up = filter(Hd, chan1_up);
chan2_up = upsample(chan2, UP);
chan2_up = filter(Hd, chan2_up);

% shift frequency up, combine both channels
t = 0:1/F_S/UP:(length(chan1_up) - 1)/F_S/UP;
tx = chan1_up.*exp(2*pi*j*F_S*t) + chan2_up.*exp(-1*pi*j*2*F_S*t);

tx = awgnChannel(tx, noise_variance, F_S*UP, 0, 0, 0, 0);


plot_spectrum(tx, F_S*UP);

nfft = 1024;

alpha1 = 0;
alpha2 = F_S/8;
alpha3 = F_S/4;
alpha4 = 3*F_S/8;
alpha5 = F_S/2;
alpha6 = F_S/16;

cyc1 = cyclic_spectrum(tx, alpha1, nfft, F_S*UP) ;
cyc2 = cyclic_spectrum(tx, alpha2, nfft, F_S*UP) ;
cyc3 = cyclic_spectrum(tx, alpha3, nfft, F_S*UP) ;
cyc4 = cyclic_spectrum(tx, alpha4, nfft, F_S*UP) ;
cyc5 = cyclic_spectrum(tx, alpha5, nfft, F_S*UP) ;
cyc6 = cyclic_spectrum(tx, alpha6, nfft, F_S*UP) ;

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
    
plot_cyc_spec(tx, F_S/16, nfft, F_S*UP);
plot_cyc_spec(tx, F_S/8, nfft, F_S*UP);
plot_cyc_spec(tx, F_S/4, nfft, F_S*UP);
plot_cyc_spec(tx, F_S/2, nfft, F_S*UP);
plot_cyc_spec(tx, F_S, nfft, F_S*UP);
plot_cyc_spec(tx, 2*F_S, nfft, F_S*UP);
