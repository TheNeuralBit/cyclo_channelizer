close all;
default_config;

numbits = 2048*10;
input_bits = text_file_to_binary('tale_of_two_cities.txt');
input_bits = input_bits(1:numbits);
PN = 40;
bauds = [F_S/8, F_S/16, F_S/4, F_S/16];
UP = length(bauds);

tx = gen_test_sig(input_bits, PN, bauds);

plot_spectrum(tx, F_S*UP);

output_samps_per_sym = 4;
channels = cyclo_and_overlap_save(tx, [F_S/16 F_S/8 F_S/4], output_samps_per_sym, F_S*UP);
plot_channels(channels, ones(length(channels), 1).*(F_S*4));

fprintf('\n');
disp('Demodulating Each Channel');
disp('-------------------------');
SAMPLES_PER_SYMBOL = output_samps_per_sym;
recompute_configuration;
for i=1:length(channels)
    fprintf('CHANNEL %d\n', i);

    bits = MyReceiver(channels{i});
    fname = sprintf('channel_%d.bits', i);
    fprintf('Writing %s...\n', fname);
    % Trim down to numbits, because we know anything after that is garbage
    % in the higher baud rate signals
    if length(bits) > numbits
        bits = bits(1:numbits);
    end
    binary_to_text_file(bits, fname);
end
