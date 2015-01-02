Core Goals
----------
- [ ] ~~Try to use cyclo detect FFT for channelizer~~
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
- [X] Polish cyclo
    - [X] Compute multiple cyclic spectra to search for frequencies with specific baud rates
    - [X] Use a single FFT for each baud
- [X] Create function for generating WB file given a list of freqs/bauds/modulations
    - [X] List of freqs
    - [ ] ~~List of modulations~~
    - [X] Allow empty channels
- [ ] Fix noise power calculation
- [ ] Move parameters to a configuration file
    - List of freqs/bauds/modulations for WB
    - List of bauds for cyclo detect
    - Sample rate/upsample
    - RC rolloff
- [ ] direct analysis/synthesis channelizer with cyclo detects
- [X] Create overlap-save filter bank
    - [X] Make os filter bank work for N channels
    - [ ] allow frequency shifting in EITHER time or frequency
        - When we do shifting in time we can relax the requirement for ldf(P, fft_size)
- Polyphase todo
    - [ ] Get channel input/output straight for synthesis/analysis channelizers (output from one should be able to go directly to the other)
    - [X] Return a cell array
    - [ ] Create combination synthesis/analysis channelizer
- [ ] Combine OS and cyclo_detect
- [ ] Comparison of runtime vs num channels with the folllowing three things:
    - cyclo and OS (without combined FFT)
    - cyclo and OS (with combined FFT)
    - cyclo and polyphase
    - Note that I need to decide how to compare - should the WB sample rate
      always be the same? Probably

Figures To Generate
-------------------
- [ ] Full SCD plot
- [ ] SCD estimates at specific baud rates for WB signal
- [ ] Output channels for OS filter bank
- [ ] Output channels for polyphase channelizer


Extras
------
- [X] Speed up packetization if I still need it
- [ ] Cache generated filters so we dont have to regenerate
- [ ] Compute graphs of Pd vs Pfa vs SNR empirically
- [ ] ~~Experiment with morphological filter for peak extraction~~
