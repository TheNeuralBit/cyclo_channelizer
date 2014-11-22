function b = design_filter(f_s, num_channels)
cutoff = f_s/num_channels/2
rp = 3;           % Passband ripple
rs = 50;          % Stopband ripple
f = [0.75*cutoff cutoff];    % Cutoff frequencies
a = [1 0];        % Desired amplitudes

% Compute deviations
dev = [(10^(rp/20)-1)/(10^(rp/20)+1)  10^(-rs/20)]; 

c = firpmord( f, a, dev, f_s, 'cell');
b = firpm(c{:});

%b=remez(511,[0 96 160 192*32]/(192*32),[1 1 0 0],[1 13]);
%b(1)=b(2)/4;
%b(2)=b(2)/2;
%b(512)=b(1);
%b(511)=b(2);
end
