function bits = text_file_to_binary(filename)
    f = fopen(filename);
    bytes = fread(f);
    bits = dec2bin(bytes) - '0';
    bits = reshape(bits', [], 1);
end
