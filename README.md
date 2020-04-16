# HADDOCK-antibody-antigen

Here we provide the code to run the antibody protocol of **HADDOCK** by using the residues belonging to the *Hyper Variable* (HV) loops.
We use [ANARCI](http://opig.stats.ox.ac.uk/webapps/newsabdab/sabpred/anarci/) *[Dunbar, J. et al (2016). Nucleic Acids Res. 44. W474-W478]* to renumber the antibody according to the Chothia numbering scheme and to identify the HV loops.

# Installation
## a. With Anaconda
The easiest way is using [Anaconda](https://www.anaconda.com/distribution/):

``` bash
git clone https://github.com/haddocking/HADDOCK-antibody-antigen.git
cd HADDOCK-antibody-antigen 

# Create conda enviroment with all the dependencies
conda env create 

# Install ANARCI
conda activate Ab-HADDOCK 
cd anarci-1.3
python2.7 setup.py install
cd ..
conda deactivate
```

## b. Without Anaconda

1. Clone the repository: 
``` bash
git clone https://github.com/haddocking/HADDOCK-antibody-antigen.git
```
2. Download and install *python 2.7*: https://www.python.org/downloads/release/python-2713/
3. Download and install *HMM 3.3*: http://hmmer.org/
4. Install the required python packages:
``` bash
cd HADDOCK-antibody-antigen 
pip install -r requirements.txt
cd ..
```
5. Install *ANARCI*:
``` bash
cd HADDOCK-antibody-antigen
cd anarci-1.3
python2.7 setup.py install
cd ..
cd ..
```

# Requirements

1. [python 2.7](https://www.python.org/downloads/release/python-2713/)
2. [HMMER](http://hmmer.org/)
3. [Biopandas](http://rasbt.github.io/biopandas/)
4. [Biopython](https://biopython.org/) 
5. [pdb-tools](https://github.com/haddocking/pdb-tools)  

# Usage  

```bash
cd HADDOCK-antibody-antigen
conda activate Ab-HADDOCK  # [optional] to run only if you have used anaconda 

# Renumber antibody with the Chothia scheme
python2.7 ImmunoPDB.py -i 4G6K.pdb -o 4G6K_ch.pdb --scheme c --fvonly  

# Format the antibody in order to fit the HADDOCK format requirements
# and extract the HV loop residues
python haddock-format.py 4G6K_ch.pdb 4G6K-HADDOCK.pdb A 

# Add END and TER statements to the .pdb file
pdb_tidy 4G6K-HADDOCK.pdb > oo; mv oo 4G6K-HADDOCK.pdb

# Deactivate anaconda
conda deactivate  # [optional] to run only if you have used anaconda 
```
