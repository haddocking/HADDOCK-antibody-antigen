# Dependencies
1. python 2.7
2. R
2. ANARCI (see installation instructions in the releated file)
2. HMMER
3. Biopython
4. bio3d
5. optparse

Exept for ANARCI the rest can be installed while creating the anaconda enviroment

# Command instructions 

```bash
cd Ab_modelling
./ImmunoPDB.py -i 4G6K.pdb -o 4G6K_ch.pdb --scheme c --fvonly  # Renumber antibody with the Chothia scheme
./match_numbering.R -f 4G6K.pdb -s 4G6K_ch.pdb -c A  # Match the numbering of the original antibody and the Chothia one
./get-HV.R -i Resno-pdb2.csv  # Extract HV loop residues
```
