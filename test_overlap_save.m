close all;
default_config;

numbits = 2048*10;
input_bits = text_file_to_binary('tale_of_two_cities.txt');
input_bits = input_bits(1:numbits);
PN = 10;
bauds = [F_S/8 F_S/4 F_S/16 F_S/8];
UP = length(bauds);

tx = gen_test_sig(input_bits, PN, bauds);
figure;
plot_spectrum(tx, F_S*UP);
t = 0:(1/F_S/UP):((length(tx)-1)/F_S/UP);
%tx = tx.*exp(1i.*2*pi.*-F_S/4.*t); %Perform frequency shift 

channel = overlap_save_channelizer(tx, .5E7, 4, F_S*UP, 1024);
figure;
plot_spectrum(channel, F_S);

SAMPLES_PER_SYMBOL = 16;
recompute_configuration;
bits = MyReceiver(channel);
fname = 'os_output.bits';
fprintf('Writing %s...\n', fname);
% Trim down to numbits, because we know anything after that is garbage
% in the higher baud rate signals
if length(bits) > numbits
    bits = bits(1:numbits);
end
binary_to_text_file(bits, fname);

disp('Done.')
