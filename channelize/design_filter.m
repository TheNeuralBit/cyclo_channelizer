function b = design_filter(D)
% design_filter - Design filter with cutoff at nyquist frequency
% Input:  D - Decimation factor. Filter cutoff will be at fs/D/2
%
% Output: b - filter impulse response
%
% Filters are cached in filt_<D>.mat so they only have to be generated once
    filename = sprintf('filt_%d.mat', D);
    if exist(filename)
        load(filename, 'b');
        return
    end
    
    %cutoff = 1/D/2;
    %rp = 3;           % Passband ripple
    %rs = 50;          % Stopband ripple
    %f = [1.0*cutoff 1.2*cutoff];    % Cutoff frequencies
    %a = [1 0];        % Desired amplitudes
    %
    %% Compute deviations
    %dev = [(10^(rp/20)-1)/(10^(rp/20)+1)  10^(-rs/20)]; 
    %
    %c = firpmord( f, a, dev, 1, 'cell');
    %b = firpm(c{:});
    
    D = fdesign.lowpass('Fp,Fst,Ap,Ast',1.0/D,1.5/D,3,50);
    Hd = design(D, 'kaiserwin');
    
    s = coeffs(Hd);
    b = s.Numerator;
    
    save(filename, 'b');

    %b=remez(511,[0 96 160 192*32]/(192*32),[1 1 0 0],[1 13]);
    %b(1)=b(2)/4;
    %b(2)=b(2)/2;
    %b(512)=b(1);
    %b(511)=b(2);
end
