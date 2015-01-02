%% Configuruable Parameters
configuration;
CYCLO_AVERAGING = 10;
%CYC_SPEC_METHOD = 'freq_shift';
CYC_SPEC_METHOD = 'one_fft';
PACKETIZE = 1;              % Whether or not to insert header bits with packet size
                            % If this is not set only message sizes that
                            % are a multiple of PACKET_SIZE_BITS will wor
CODING = 0;
MODULATION = 'QPSK';        % 16QAM or QPSK
PACKET_SIZE_BITS = 2048;    % Packet size including header bits
HEADER_SIZE_BITS = 16;
GENERATING_POLYS = [15 17];
CONSTRAINT_LENGTH = 4;      % Must be set to the appropriate value based on polys
RC_ROLLOFF = 0.25;          % Adjusts alpha of the RRC pulse shape
PHASE_WINDOW = 256;
COARSE_FFT_SIZE = 2^15;

%% Derived and Fixed Parameters (Do not modify!)
F_S = 1e7;   % given, sample rate = 10 Msps

SAMPLES_PER_SYMBOL = 4;  % given, samp/symbol >= 4

%% Cyclo Detect Parameters
CYCLO_PEAK_THRESH = 80;
CYCLO_PEAK_MIN_SPACING = 2E6;

DEBUG_FIGURES = 0; % To enable some debug figures, set this to 1

recompute_configuration;
