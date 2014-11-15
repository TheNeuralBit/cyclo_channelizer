configuration;

DATA_SIZE_BITS = PACKET_SIZE_BITS - HEADER_SIZE_BITS;
T = SAMPLES_PER_SYMBOL/F_S; % symbol time

CODE_RATE = 1/length(GENERATING_POLYS);

if strcmp(MODULATION, 'QPSK')
    M = 2;
    SYNC_PATTERN = generate_m_sequence(6);
    SYNC_PATTERN = SYNC_PATTERN(1:62);
    BITS_PER_SYMBOL = 2;
elseif strcmp(MODULATION, '16QAM')
    M = 4;
    SYNC_PATTERN = generate_m_sequence(7);
    SYNC_PATTERN = SYNC_PATTERN(1:124);
    BITS_PER_SYMBOL = 4;
else
    disp('MODULATION must be 16QAM or QPSK!!');
end

PULSE_SHAPE = generate_pulse_shaping_filt(F_S, T, RC_ROLLOFF);

PACKET_SIZE_SAMPLES = PACKET_SIZE_BITS/CODE_RATE*SAMPLES_PER_SYMBOL/M;

