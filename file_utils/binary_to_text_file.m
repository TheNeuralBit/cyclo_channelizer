function binary_to_text_file(bits, filename)
    bits = bits(1:length(bits) - mod(length(bits), 8));
    bytes = reshape(bits, 8, [])';
    bit_vals = 2.^[7:-1:0];
    f = fopen(filename, 'w');
    fwrite(f, sum(bytes.*repmat(bit_vals, size(bytes, 1), 1), 2));
    fclose(f);
end
