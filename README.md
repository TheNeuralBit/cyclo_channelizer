Channelizer Structures Directed by Cyclostationary Detector
===========================================================
A simulation of two different channelizer structures (polyphase
analysis/synthesis channelizer and overlap-save filter bank), directed by
a cyclostationary detector. Simple QPSK signals are used for tessting, but the
concepts and software should be applicable to many other signal types.

This is based on my Master of Engineering work at Virginia Tech. A copy of my
report, "Simulation of Various Channelizer Structures Directed by
Cyclostationary Detector," can be found by following the link below:

[![PDF Status](https://www.sharelatex.com/github/repos/TheNeuralBit/cyclo_channelizer/builds/latest/badge.svg)](https://www.sharelatex.com/github/repos/TheNeuralBit/cyclo_channelizer/builds/latest/output.pdf)

Running the Simulation
----------------------
To run the simulation you must first setup your path. In MATLAB, if this
repository is your current working directory you should be able to simply run:

    >> setup_path

Then you can run any one of the ``test_*.m`` scripts:
<dl>
<dt>test_cyclo.m</dt>
<dd>Tests functions for estimating the SCD</dd>

<dt>test_cyclo_detect.m</dt>
<dd>Tests actually detecting signals using the SCD</dd>

<dt>test_overlap_save.m</dt>
<dd>Tests the Overlap-Save Filter Bank</dd>

<dt>test_cyclo_os.m</dt>
<dd>Tests the Overlap-Save Filter Bank combined with SCD estimation/cyclo detection</dd>

<dt>test_polyphase.m</dt>
<dd>Tests the polyphase analysis channelizer</dd>

<dt>test_synthesis_chan.m</dt>
<dd>Tests the polyphase sythesis channelizer</dd>

<dt>test_cyclo_poly.m</dt>
<dd>Tests the combined polyphase analysis/synthesis channelizer directed by the
cyclo detector</dd>
</dl>
