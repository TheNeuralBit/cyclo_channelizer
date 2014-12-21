close all;
default_config;

numbits = 2048*10;
input_bits = text_file_to_binary('tale_of_two_cities.txt');
input_bits = input_bits(1:numbits);
PN = 10;
bauds = [F_S/4 F_S/8 F_S/8 F_S/8];
UP = length(bauds);

tx = gen_test_sig(input_bits, PN, bauds);
figure;
plot_spectrum(tx, F_S*UP);
t = 0:(1/F_S/UP):((length(tx)-1)/F_S/UP);
tx = tx.*exp(1i.*2*pi.*F_S/2.*t); %Perform frequency shift 

figure;
plot_spectrum(tx, F_S*UP);

%bits = MyReceiver(tx);
%binary_to_text_file(bits, 'test_0.txt');


channels = analysis_channelizer(tx, length(bauds), F_S*UP);
plot_channels(channels, F_S);

%% Plot results
%disp('Plotting results...')
for i=1:length(bauds)
    %figure;
    %plot_spectrum(channels(i,:), F_S*UP/length(bauds));
    SAMPLES_PER_SYMBOL = F_S/bauds(i)
    recompute_configuration;
    bits = MyReceiver(channels(i,:));
    fname = sprintf('test_%d.txt', i);
    fprintf('Writing %s...\n', fname);
    % Trim down to numbits, because we know anything after that is garbage
    % in the higher baud rate signals
    if length(bits) > numbits
        bits = bits(1:numbits);
    end
    binary_to_text_file(bits, fname);
end

reconstruction = synthesis_channelizer(channels, F_S);
t = 0:(1/F_S/UP):((length(reconstruction)-1)/F_S/UP);
reconstruction = reconstruction.*exp(1i.*2*pi.*F_S/4.*t); %Perform frequency shift 
figure;
plot_spectrum(reconstruction, F_S*UP);

disp('Done.')
