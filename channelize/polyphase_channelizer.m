function [output] = polyphase_channelizer(data, freqs, decimations, F_S)
    output = cell(length(freqs), 1);

    D = max(decimations);
    split_channels = analysis_channelizer(data, D, F_S);
    split_f_s = F_S/D;

    % TODO: correct freq offset
    for i=1:length(freqs)
        freq = freqs(i)
        dec = decimations(i)
        out_f_s = F_S/dec;
        if dec == D
            output{i} = split_channels{round(D*(freq/F_S + 0.5))}
        else
            nearest_bin = round(D*(freq/F_S + 1.0/2 + 1.0/2/D))
            num_bins = D/dec
            min_bin = nearest_bin - num_bins/2
            max_bin = nearest_bin + num_bins/2 - 1
            output{i} = synthesis_channelizer(split_channels(min_bin:max_bin), F_S);

            % Compute offset
            f_off = freq - (nearest_bin*out_f_s - F_S/2 - out_f_s/2);

            % Perform frequency shift 
            t = 0:(1/out_f_s):((length(output{i})-1)/out_f_s);
            output{i} = output{i}.*exp(1i.*2.*pi.*(f_off - split_f_s).*t);
        end
    end
end
