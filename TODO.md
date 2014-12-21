Core Goals
----------
- [X] Figure out simple channelizer
    - [X] Figure out why channels are offset by half channel spacing
        - Because thats how the channelizer works - valid frequencies are integer multiples of the output sample rate (since we rely on aliasing for tuning)
    - [X] Fix channelized output first and second halves being switched
- [X] Create simple synthesis channelizer for recombining adjacent channels
    - [X] Create synthesis channelizer test
    - [ ] Perfect reconstruction filter?
- [X] Try to do cyclo detect with only one FFT (by aligning baud and fft spacing)
- [X] Average cyclo detects over time
- [X] Rolloff filter faster? Why are we getting aliasing from neighboring channels
    - Seems like filter is sharp enough... tried just filtering a single channel and downsampling and everything was fine
    - Definitely related to the goofy sidebands we get in "test_synthesis_chan"... If I can figure that out I think we're golden
    - Problem was caused by synthesis channelizer input commutator running in the wrong direction - resolved now
- [X] Create function for generating WB file given a list of freqs/bauds/modulations
    - [ ] List of freqs
    - [ ] List of modulations
    - [ ] Allow empty channels
- [ ] Fix noise power calculation
- [ ] Move parameters to a configuration file
    - List of freqs/bauds/modulations for WB
    - List of bauds for cyclo detect
    - Sample rate/upsample
    - RC rolloff
- [ ] Create combination synthesis/analysis channelizer
- [ ] direct analysis/synthesis channelizer with cyclo detects
- [ ] ~~Try to use cyclo detect FFT for channelizer~~
- [X] Create overlap-save filter bank
    - [ ] Make os filter bank work for N channels
- [ ] Get channel input/output straight for synthesis/analysis channelizers (output from one should be able to go directly to the other)


Extras
------
- [ ] Experiment with morphological filter for peak extraction
- [ ] Compute graph of Pd vs Pfa vs SNR empirically
- [ ] Speed up packetization if I still need it
