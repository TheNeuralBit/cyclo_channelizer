close all;
configuration;

numbits = 2048*100;
input_bits = randn(1, numbits)<0;
EBNO = 20;

UP = 4;

%% Other Parameters
SAMPLES_PER_SYMBOL = 4;  % given, samp/symbol >= 4
EsNo = CODE_RATE.*BITS_PER_SYMBOL.*10.^(0.1.*EBNO);
% EsNo = CODE_RATE.*BITS_PER_SYMBOL.*10.^(0.1.*EBNO);
noise_variance = 1./(2.*EsNo); % Convert Es_No to variance

%% Run the Transmitter
%tx = MyTransmitter(input_bits);
% Generate channel 1 at baud rate fs/4
chan1 = simple_tx(input_bits(1:length(input_bits)/4), 'QPSK', 16, F_S);
% Generate channel 2 at baud rate fs/8
chan2 = simple_tx(input_bits(1:length(input_bits)/2), 'QPSK', 8, F_S);
 
% upsample data
Hd=design(fdesign.lowpass('Fp,Fst',3/4/UP, 1/UP), 'equiripple');

chan1 = upsample(chan1, UP);
chan1 = filter(Hd, chan1);
chan2 = upsample(chan2, UP);
chan2 = filter(Hd, chan2);

% shift frequency up, combine both channels
t = 0:1/F_S/UP:(length(chan1) - 1)/F_S/UP;
tx = chan1.*exp(2*pi*j*F_S*t) + chan2.*exp(-1*pi*j*2*F_S*t);

tx = awgnChannel(tx, noise_variance, F_S, 0, 0, 0, 0);


plot_spectrum(tx, F_S*UP);

nfft = 256;

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

f = linspace(-F_S/2, F_S/2, nfft);

figure;
h1 = axes;
plot3(f, alpha1*ones(1,nfft), abs(cyc1), '-b', ...
      f, alpha2*ones(1,nfft), abs(cyc2), '-b', ...
      f, alpha3*ones(1,nfft), abs(cyc3), '-b', ...
      f, alpha4*ones(1,nfft), abs(cyc4), '-b', ...
      f, alpha5*ones(1,nfft), abs(cyc5), '-b', ...
      f, alpha6*ones(1,nfft), abs(cyc6), '-b');
set(h1, 'Ydir', 'reverse');
    
%plot_cyc_spec(tx, 0,     nfft, F_S*UP);
%plot_cyc_spec(tx, 1000,  nfft, F_S*UP);
%plot_cyc_spec(tx, F_S/2, nfft, F_S*UP);
%plot_cyc_spec(tx, F_S/4, nfft, F_S*UP);
%plot_cyc_spec(tx, F_S/8, nfft, F_S*UP);
%plot_cyc_spec(tx, 4E6,   nfft, F_S*UP);

%spec_size = 100;
%cyc_spec = zeros(spec_size, nfft);
%for idx = 1:spec_size
%    alpha = (idx-1)/spec_size*(F_S); % scale alpha from 0 to F_S/2
%    cyc_spec(idx,:) = cyclic_spectrum(tx, alpha, nfft, F_S*UP);
%end
%
%%surf(10*log(abs(cyc_spec)));
%surf(abs(cyc_spec));
