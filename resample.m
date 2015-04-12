function [output_data] = resample(input_data, in_fs, out_fs)
    total_time = length(input_data)/in_fs;
    in_t  = 0:1/in_fs:total_time;
    in_t = in_t(1:length(input_data));
    out_t = 0:1/out_fs:total_time;
    output_data = interp1(in_t, input_data, out_t, 'pchip');
end
