close all;
default_config;

numbits = 2048*10;
input_bits = text_file_to_binary('tale_of_two_cities.txt');
input_bits = input_bits(1:numbits);
PN = 10;
bauds = [1/4 1/8 1/8 1/8].*F_S/4;
UP = length(bauds);
output_f_s = F_S/UP;

freqs = -F_S/2:output_f_s:F_S/2;
freqs = freqs(1:end-1) + output_f_s/2;

disp('Generating Test Signal');
disp('----------------------');
tx = gen_test_sig(input_bits, PN, bauds, freqs);
figure;
plot_spectrum(tx, F_S);
t = 0:(1/F_S):((length(tx)-1)/F_S);

tx = tx.*exp(1i.*2*pi.*output_f_s/2.*t); %Perform frequency shift 

figure;
plot_spectrum(tx, F_S);

fprintf('\n');
disp('Running Analysis Channelizer');
disp('----------------------------');
channels = analysis_channelizer(tx, length(bauds), F_S);
plot_channels(channels, F_S*ones(4,1));

fprintf('\n');
disp('Demodulating Each Channel');
disp('-------------------------');
%% Plot results
%disp('Plotting results...')
for i=1:length(bauds)
    fprintf('CHANNEL %d\n', i);
    SAMPLES_PER_SYMBOL = output_f_s/bauds(i);
    recompute_configuration;
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

fprintf('\n');
disp('Running Synthesis Channelizer');
disp('-----------------------------');
reconstruction = synthesis_channelizer(channels, output_f_s);
t = 0:(1/F_S):((length(reconstruction)-1)/F_S);
reconstruction = reconstruction.*exp(1i.*2*pi.*output_f_s.*t); %Perform frequency shift 
figure;
plot_spectrum(reconstruction, F_S);

disp('Done.')
