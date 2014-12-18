close all;
default_config;

numbits = 2048*10;
input_bits = text_file_to_binary('tale_of_two_cities.txt');
input_bits = input_bits(1:numbits);

tx = MyTransmitter(input_bits);
t = 0:(1/F_S):((length(tx)-1)/F_S);
tx = tx.*exp(1i.*2.*pi.*-F_S/2.*t); %Perform frequency shift 

plot_spectrum(tx, F_S);

%perfect_bits = MyReceiver(tx);
%binary_to_text_file(perfect_bits, 'perfect_bits.txt');
%sum(abs(input_bits-perfect_bits'))/numbits*100

channels = analysis_channelizer(tx, 2, F_S);
plot_channels(channels, F_S/size(channels,1));


output = synthesis_channelizer(channels, F_S/2);

t = 0:(1/F_S):((length(output)-1)/F_S);
output = output.*exp(1i.*2.*pi.*F_S/2.*t); %Perform frequency shift 
figure;
plot_spectrum(output, F_S);

reconstructed_bits = MyReceiver(output);
binary_to_text_file(reconstructed_bits, 'reconstructed_bits.txt');
size(input_bits)
size(reconstructed_bits)
sum(abs(input_bits-reconstructed_bits(1:numbits)'))/numbits*100
