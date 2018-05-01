Fine-tuning and the stability of recurrent neural networks
==========================================================

1. Unzip the OMS model (v1.4) which can be found at
   http://www.omlab.org/software/software.html

2. Uncomment and modify the second and third lines of `NIdemo.m` such
   that the file path points to the location where the OMS model was
   unzipped.

3. Run the `NIdemo.m` file in MATLAB

Two plots will be shown after the simulation is complete. The first is
a plot of the optimal, noisy and learned decoders. The second plot is
an animation of the integrator learning throughout the duration of the
simulation.

* NOTE: The OMSv1_4_mod_NEF_NI.mdl file is based on a prior model from
  http://www.omlab.org/software/software.html

Changes from the original model are described in a separate research
paper.
