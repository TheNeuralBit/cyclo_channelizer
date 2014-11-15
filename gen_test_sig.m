function [tx] = gen_test_sig(bits, noise_power, channel_bauds )
configuration;
num_sigs = length(channel_bauds);
UP = num_sigs;

for baud=channel_bauds
    if mod(F_S, baud) ~= 0
        disp('Baud rates must all be a multiple of Sample Rate!');
        tx=0;
        return;
    end
end

samps_per_sym =  F_S./channel_bauds;

%% Run the Transmitter
Hd=design(fdesign.lowpass('Fp,Fst',3/4/UP, 1/UP), 'equiripple');
tx = [];
for idx=1:num_sigs
    % Generate
    sig = gen_sig(bits, samps_per_sym(idx), MODULATION);

    % Upsample, Filter and Frequency Shift
    sig = filter(Hd, upsample(sig, UP));
    pos = idx - 0.5 - num_sigs/2;
    t = 0:1/F_S/UP:(length(sig) - 1)/F_S/UP;
    sig = sig.*exp(1*pi*j*pos*2*F_S*t);

    % Add to WB signal
    tx = add_and_zero_pad(tx, sig);
end

% Compute Noise variance based on desired noise power
% pretty sure this is wrong
noise_variance = 10.^(0.1*noise_power)/(F_S*UP*2);

% add noise
tx = awgnChannel(tx, noise_variance, F_S*UP, 0, 0, 0, 0);

end

function [samples] = gen_sig(bits, samples_per_sym, modulation)
    configuration;
    SAMPLES_PER_SYMBOL = samples_per_sym;
    recompute_configuration;
    samples = MyTransmitter(bits);
end

function [result] = add_and_zero_pad(left, right)
    if length(left) == length(right)
        result = left + right;
        return
    end
    if length(left) > length(right)
        tmp = left;
        left = right;
        right = tmp;
    end
    left = [left zeros(1, length(right) - length(left))];
    result = left + right;
end
