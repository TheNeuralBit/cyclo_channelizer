function [tx] = gen_test_sig(bits, noise_power, channel_bauds )
configuration;
num_sigs = length(channel_bauds);
UP = num_sigs;
modulation = 'QPSK';
bits_per_symbol = 2;

for baud=channel_bauds
    if mod(F_S, baud) ~= 0
        disp('Baud rates must all be a multiple of Sample Rate!');
        tx=0;
        return;
    end
end

samps_per_sym =  F_S./channel_bauds;

shortest_sig_len = length(bits)/bits_per_symbol*min(samps_per_sym);
bit_lengths = shortest_sig_len*bits_per_symbol./samps_per_sym;

%% Run the Transmitter
sigs = zeros(num_sigs, shortest_sig_len);
for idx=1:num_sigs
    sigs(idx,:) = gen_sig(bits(1:bit_lengths(idx)), samps_per_sym(idx), modulation)';
end

% upsample data
Hd=design(fdesign.lowpass('Fp,Fst',3/4/UP, 1/UP), 'equiripple');

tx = zeros(1, shortest_sig_len*UP);
t = 0:1/F_S/UP:(length(tx) - 1)/F_S/UP;
for idx=1:num_sigs
    pos = idx - 0.5 - num_sigs/2;
    % upsample the channel, frequency shift it to appropriate location
    tx = tx + filter(Hd, upsample(sigs(idx,:), UP)).*exp(1*pi*j*pos*2*F_S*t);
end

% Compute Noise variance based on desired noise power
% pretty sure this is wrong
noise_variance = 10.^(0.1*noise_power)/(F_S*UP*2);

% add noise
tx = awgnChannel(tx, noise_variance, F_S*UP, 0, 0, 0, 0);

end

function [samples] = gen_sig(bits, samples_per_sym, modulation)
    configuration;
    samples = simple_tx(bits, modulation, samples_per_sym, F_S, RC_ROLLOFF);
end
