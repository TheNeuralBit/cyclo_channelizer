Core Goals
----------
- [ ] Fix noise power calculation
- [X] Create function for generating WB file given a list of freqs/bauds/modulations
    - [ ] List of freqs
    - [ ] List of modulations
    - [ ] Allow empty channels
- [ ] Move parameters to a configuration file
    - List of freqs/bauds/modulations for WB
    - List of bauds for cyclo detect
    - Sample rate/upsample
    - RC rolloff
- [X] Figure out simple channelizer
    - [ ] Figure out why channels are offset by half channel spacing
    - [X] Fix channelized output first and second halves being switched
- [X] Create simple synthesis channelizer for recombining adjacent channels
    - [ ] Create synthesis channelizer test
    - [ ] Perfect reconstruction filter?
- [ ] Create combination synthesis/analysis channelizer
- [X] Try to do cyclo detect with only one FFT (by aligning baud and fft spacing)
- [X] Average cyclo detects over time
- [ ] direct analysis/synthesis channelizer with cyclo detects
- [ ] Speed up packetization if I still need it
- [ ] ~~Try to use cyclo detect FFT for channelizer~~


Extras
------
- [ ] Experiment with morphological filter for peak extraction
