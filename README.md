# HADDOCK-antibody-antigen

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)
[![unittests](https://github.com/haddocking/HADDOCK-antibody-antigen/actions/workflows/main.yml/badge.svg)](https://github.com/haddocking/HADDOCK-antibody-antigen/actions/workflows/main.yml)
[![DOI](https://zenodo.org/badge/241584375.svg)](https://zenodo.org/badge/latestdoi/241584375)

Here we provide the code to run the antibody protocol of **HADDOCK** by using the residues belonging to the _hypervariable_ (**HV**) loops.
We use [ANARCI](http://opig.stats.ox.ac.uk/webapps/newsabdab/sabpred/anarci/) _[Dunbar, J. et al (2016). Nucleic Acids Res. 44. W474-W478]_ to renumber the antibody according to the Chothia numbering scheme and to identify the HV loops.

## Installation

Install it using [Conda](https://docs.conda.io/en/latest/miniconda.html).

```bash
git clone https://github.com/haddocking/HADDOCK-antibody-antigen.git
cd HADDOCK-antibody-antigen

# Create conda environment from environment.yaml file:
conda env create -f environment.yaml
conda activate haddock-antibody
```

If you are still using Python 2, please, consider using [older version](https://github.com/haddocking/HADDOCK-antibody-antigen/releases/tag/2020-first-release)

## Usage

### As separate scripts

```bash
conda activate haddock-antibody

# Renumber antibody with the Chothia scheme
python ImmunoPDB.py -i 4G6K.pdb -o 4G6K_ch.pdb --scheme c --fvonly --rename --splitscfv

# Format the antibody in order to fit the HADDOCK format requirements
# and extract the HV loop residues and save them into a file
python ab_haddock_format.py 4G6K_ch.pdb 4G6K-HADDOCK.pdb A > active.txt

# Add END and TER statements to the .pdb file
pdb_tidy 4G6K-HADDOCK.pdb > oo; mv oo 4G6K-HADDOCK.pdb
```

### As one command

For the convenience all three commands can be run as one command with:

```bash
conda activate haddock-antibody

python run.py --pdb 4G6K.pdb
```

It is also possible to process a whole folder with pdb files as well as subfolders with only one command:

```bash
conda activate haddock-antibody

python run.py --pdb folder_with_pdbs
```

## Limitations

The version of `ImmunoPDB.py` script that we are re-distributing as part of this protocol has some limitations and cannot handle all naming schemes, please se the list below:

- martin ✅
- chotia ✅
- imgt ❌
- kabat ✅
- aho ❌
- wolguy ❌

Issues with this script are out of the scope of this repository, please raise an issue at the [ANARCI repository](https://github.com/oxpig/ANARCI/issues) if you have any problems with it.

* * *