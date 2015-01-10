function b = design_filter(num_channels)
filename = sprintf('filt_%d.mat', num_channels);
if exist(filename)
    load(filename, 'b');
    return
end

cutoff = 1/num_channels/2;
rp = 3;           % Passband ripple
rs = 50;          % Stopband ripple
f = [0.8*cutoff 1.2*cutoff];    % Cutoff frequencies
a = [1 0];        % Desired amplitudes

% Compute deviations
dev = [(10^(rp/20)-1)/(10^(rp/20)+1)  10^(-rs/20)]; 

c = firpmord( f, a, dev, 1, 'cell');
b = firpm(c{:});

Hd=design(fdesign.lowpass('Fp,Fst',0.9/num_channels, 1.2/num_channels), 'equiripple');

s = coeffs(Hd);
b = s.Numerator;

save(filename, 'b');

%b=remez(511,[0 96 160 192*32]/(192*32),[1 1 0 0],[1 13]);
%b(1)=b(2)/4;
%b(2)=b(2)/2;
%b(512)=b(1);
%b(511)=b(2);
end
