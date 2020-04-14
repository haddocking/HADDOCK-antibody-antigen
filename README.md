# HADDOCK-antibody-antigen

Here we provide the code to run the antibody protocol of **HADDOCK** by using the residues belonging to the *Hyper Variable* (HV) loops.
We use [ANARCI](http://opig.stats.ox.ac.uk/webapps/newsabdab/sabpred/anarci/) *[Dunbar, J. et al (2016). Nucleic Acids Res. 44. W474-W478]* to renumber the antibody according to the Chothia numbering scheme and to identify the HV loops.

# Installation
#### a. With anaconda
The easiest way is using [Anaconda](https://www.anaconda.com/distribution/).

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

### b. Without Anaconda

1. Clone the repository: 
``` bash
git clone https://github.com/haddocking/HADDOCK-antibody-antigen.git
```
2. Download and install *python 2.7*: https://www.python.org/
3. Download and install *R 3.6.0*: https://www.r-project.org/
4. Download and install *HMM 3.3*: http://hmmer.org/
5. Install the python library: *Biopython*:
``` bash
pip install biopython
```
6. Install the R packages: *Bio3d* and *optparse*:
``` bash
cd HADDOCK-antibody-antigen 
Rscript install_pkgs.R
cd ..
```
7. Install *ANARCI*
``` bash
cd HADDOCK-antibody-antigen
cd anarci-1.3
python setup.py install
cd ..
cd ..
```

# Requirements

1. [python 2.7](https://www.python.org/)
2. [R](https://www.r-project.org/)
3. [HMMER](http://hmmer.org/)
4. [Biopython](https://biopython.org/) 
5. [bio3d](http://thegrantlab.org/bio3d/index.php)  
6. [optparse](https://github.com/trevorld/r-optparse)

# Usage  

```bash
cd HADDOCK-antibody-antigen
conda activate Ab-HADDOCK # [optional] to run only if you have used anaconda 

# Renumber antibody with the Chothia scheme
./ImmunoPDB.py -i 4G6K.pdb -o 4G6K_ch.pdb --scheme c --fvonly  

# Format the antibody in order to fit the HADDOCK format requirements
./HADDOCK-format.R -i 4G6K_ch.pdb -o 4G6K-HADDOCK.pdb -c A  

# Extract HV loop residues
./get-HV.R -i 4G6K-HADDOCK.csv  
```