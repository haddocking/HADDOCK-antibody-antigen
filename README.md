# HADDOCK-antibody-antigen

Here we provide the code to run the antibody protocol of **HADDOCK** by using the residues belonging to the *Hyper Variable* (HV) loops.
We use ANARCI (http://opig.stats.ox.ac.uk/webapps/newsabdab/sabpred/anarci/) *[Dunbar, J. et al (2016). Nucleic Acids Res. 44. W474-W478]* to renumber the antibody accoring to the Chothia numbering scheme and to identify the HV loops.

# Installation

The easiest way is using Anaconda (https://www.anaconda.com/distribution/).

``` bash
git clone https://github.com/haddocking/HADDOCK-antibody-antigen.git
cd HADDOCK-antibody-antigen 

# Create conda enviroment with all the dependencies
conda create env 

# Install ANARCI
cd anarci-1.3
python setup.py install
cd ..
```

# Requirements

Dependencies can be installed using anaconda or following the instructions in the corresponding websites:

1. python 2.7 (https://www.python.org/)
2. R (https://www.r-project.org/)
3. ANARCI (http://opig.stats.ox.ac.uk/webapps/newsabdab/sabpred/anarci/)
4. HMMER (http://hmmer.org/)
5. Biopython (https://biopython.org/)
6. bio3d (http://thegrantlab.org/bio3d/index.php)
7. optparse (https://github.com/trevorld/r-optparse)


# Usage  

```bash
cd HADDOCK-antibody-antigen
conda activate Ab-HADDOCK

# Renumber antibody with the Chothia scheme
./ImmunoPDB.py -i 4G6K.pdb -o 4G6K_ch.pdb --scheme c --fvonly  

# Match the numbering of the original antibody and the Chothia one
./match_numbering.R -f 4G6K.pdb -s 4G6K_ch.pdb -c A  

# Extract HV loop residues
./get-HV.R -i Resno-pdb2.csv  
```
