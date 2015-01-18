function [output] = polyphase_channelizer(data, freqs, decimations, F_S)
% polyphase_channelizer - Use combined polyphase analysis/synthesis channelizer
%                         to output channels at each desired center frequency
% Input:  data        - 1D vector of time domain data. Wideband signal to
%                       be filtered.
%         freqs       - List of output center frequencies
%         decimations - List of corresponding decimation factors
%         F_S         - input sample rate
% Output: output      - 1xD cell array of time domain data for each channel.
%                       item at index k has center frequency -fs/2 + kfs/D
    configuration;

    output = cell(length(freqs), 1);

    D = max(decimations);
    split_channels = analysis_channelizer(data, D);
    split_f_s = F_S/D;
    if DEBUG_FIGURES
        plot_channels(split_channels, repmat(split_f_s, D, 1), ...
                      'AxisLabels', 0, 'YMin', -60, 'YMax', 20);
    end

    for i=1:length(freqs)
        freq = freqs(i)
        dec = decimations(i)
        out_f_s = F_S/dec;
        if dec == D
            output{i} = split_channels{round(D*(freq/F_S + 0.5))}
        else
            nearest_bin = round(D*(freq/F_S + 1.0/2 + 1.0/2/D));
            num_bins = D/dec;
            min_bin = nearest_bin - num_bins/2;
            max_bin = nearest_bin + num_bins/2 - 1;
            output{i} = synthesis_channelizer(split_channels(min_bin:max_bin));

            % Compute offset
            nearest_freq = nearest_bin*split_f_s - F_S/2 - split_f_s/2;
            f_off = freq - nearest_freq;

            % Perform frequency shift 
            t = 0:(1/out_f_s):((length(output{i})-1)/out_f_s);
            output{i} = output{i}.*exp(1i.*2.*pi.*(-f_off + split_f_s/2).*t);
        end
    end
end
