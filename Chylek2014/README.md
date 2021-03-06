# Chylek 2014
## Reference
Chylek, L. A., Holowka, D. A., Baird, B. A., & Hlavacek, W. S. (2014). AN INTERACTION LIBRARY FOR THE FcεRI SIGNALING NETWORK. *Frontiers in Immunology*, **5**, 1–42. https://doi.org/10.3389/fimmu.2014.00172

## Contents
Supplementary Files 1-3 are BioNetGen input files with .bngl extensions. 
They are plain-text files that can be processed by BioNetGen (http://bionetgen.org).

The complete library of rules is given in Supplementary File 1. 
This file can be simulated with BioNetGen, which uses the built-in network-free simulator (NFsim) to produce simulation results because the full reaction network is too large to enumerate. 
However, this file is not meant to provide a model but rather a library of rules from which models can be constructed. 
Simulation instructions that can be passed to NFsim, which can be invoked separately, are included in Supplementary File 4,
which is a plain-text file with a .rnf extension.

Supplementary File 2 provides an executable specification of the example model of Fig. 5. 
This file can be processed by BioNetGen to produce simulation results.

Supplementary File 3 provides an executable specification of the example model of Fig. 7.
This file can be processed by BioNetGen to produce simulation results.

A modified form of the File 2 model was used to generate Fig. 6, and a modified form of the File 3 model was used to generate Fig. 8. For both sets of simulations, an input representing a stimulus was used to control the rate of activation of Syk and Fyn. Syk and Fyn were both deactivated through first-order processes. The extra rules and parameters are below. The level of stimulus is set to a number between 0 and 1, which causes generation of active Syk and Fyn. 

<pre>
Parameters: 
ksynthS  0.5*SimProteinTot # This number will be the steady-state level of active Syk when stimulus is set to 1 
kdegS 1
ksynthF 0.5*SimProteinTot # This number will be the steady-state level of active Fyn when stimulus is set to 1
kdegF 1

Rules: 
# Syk is activated
stimulus -> stimulus + Syk(cat) ksynthS
# Syk is deactivated
Syk(cat) -> zero kdegS
# Fyn is actvated
stimulus -> stimulus + Fyn(cat) ksynthF
# Fyn is deactivated
Fyn(cat) -> zero kdegF
</pre>

A slightly simpler way to implement this using newer BNGL syntax is as follows:
<pre>
0 <-> Syk(cat) stim*SykTot*kdegS, kdegS
0 <-> Fyn(cat) stim*FynTot*kdegF, kdegF
</pre>
where `SykTot` and `FynTot` are the desired steady state levels of Syk and Fyn respectively and `stim` is used to determine the fraction of these levels that are achieved.
