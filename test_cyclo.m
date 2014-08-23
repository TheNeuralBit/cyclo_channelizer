close all;
configuration;

numbits = 2048*100;
input_bits = randn(1, numbits)<0;
EBNO = 50;

UP = 4;

%% Other Parameters
SAMPLES_PER_SYMBOL = 4;  % given, samp/symbol >= 4
EsNo = CODE_RATE.*BITS_PER_SYMBOL.*10.^(0.1.*EBNO);
% EsNo = CODE_RATE.*BITS_PER_SYMBOL.*10.^(0.1.*EBNO);
noise_variance = 1./(2.*EsNo); % Convert Es_No to variance

%% Run the Transmitter
%tx = MyTransmitter(input_bits);
tx = simple_tx(input_bits);
 
tx = awgnChannel(tx, noise_variance, F_S, 0, 0, 0, 0);

% upsample data
tx = upsample(tx, UP);
Hd=design(fdesign.lowpass('Fp,Fst',3/4/UP, 1/UP), 'equiripple');
tx = filter(Hd, tx);

% shift frequency up
t = 0:1/F_S/UP:(length(tx) - 1)/F_S/UP;
tx = tx.*exp(2*pi*j*F_S*t);

plot_spectrum(tx, F_S*UP);

nfft = 1024;

plot_cyc_spec(tx, 0,     nfft, F_S*UP);
plot_cyc_spec(tx, 1000,  nfft, F_S*UP);
plot_cyc_spec(tx, F_S/2, nfft, F_S*UP);
plot_cyc_spec(tx, F_S/4, nfft, F_S*UP);
plot_cyc_spec(tx, F_S/8, nfft, F_S*UP);
plot_cyc_spec(tx, 4E6,   nfft, F_S*UP);

spec_size = 100;
cyc_spec = zeros(spec_size, nfft);
for idx = 1:spec_size
    alpha = (idx-1)/spec_size*(F_S); % scale alpha from 0 to F_S/2
    cyc_spec(idx,:) = cyclic_spectrum(tx, alpha, nfft, F_S*UP);
end

%surf(10*log(abs(cyc_spec)));
surf(abs(cyc_spec));
