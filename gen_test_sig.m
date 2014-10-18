function [tx] = gen_test_sig(bits, noise_power)
configuration;
UP = 4;

% Compute Noise variance based on desired noise power
% pretty sure this is wrong
noise_variance = 10.^(0.1*noise_power)/(F_S*UP*2);

%% Run the Transmitter
%tx = MyTransmitter(bits);
% Generate channel 1 at baud rate fs/4
chan1 = simple_tx(bits(1:length(bits)/4), 'QPSK', 16, F_S, .25);
% Generate channel 2 at baud rate fs/8
chan2 = simple_tx(bits(1:length(bits)/2), 'QPSK', 8, F_S, .25);
 
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

end
