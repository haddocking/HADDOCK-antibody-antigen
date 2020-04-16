#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright 2020:
#   Francesco Ambrosetti
#

"""
Formats the antibody to fit the HADDOCK requirements with the
specified chain id and returns the list of residues belonging
to the HV loops defined according to the HADDOCK friendly format.

Usage:
    python haddock-format.py <chothia numbered antibody> <output .pdb file> <chain_id>

Example:
    python 4G6K_ch.pdb 4G6K-HADDOCK.pdb A

Author: {0}
Email: {1}
"""

import argparse
import biopandas.pdb as bp
import copy as cp
import os
import sys

__author__ = "Francesco Ambrosetti"
__email__ = "ambrosetti.francesco@gmail.com"
USAGE = __doc__.format(__author__, __email__)


def check_input():
    """
    Check and collect the script inputs
    Returns:
        args.pdb (str): path to the pdb-file
        args.chain (str): chain id to use for the HADDOCK-formatted structure
    """

    # Parse command line arguments
    parser = argparse.ArgumentParser(
        description=USAGE,
        formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('pdb', help='Path to the pdb-file', type=str)
    parser.add_argument('out', help='Path to the output file', type=str)
    parser.add_argument('chain', help='Chain id to use for the HADDOCK-formatted structure', type=str)

    args = parser.parse_args()

    if not os.path.isfile(args.pdb):
        emsg = 'ERROR!! File {0} not found or not readable\n'.format(args.pdb)
        sys.stderr.write(emsg)
        sys.exit(1)

    if not args.pdb.end.endswith(".pdb"):
        emsg = 'ERROR!! File {0} not recognize as a PDB file\n'.format(args.pdb)
        sys.stderr.write(emsg)
        sys.exit(1)

    return args.pdb, args.out, args.chain


def unique(sequence):
    seen = set()
    return [x for x in sequence if not (x in seen or seen.add(x))]


class AbHaddockFormat:
    """Class to renumber a Chothia antibody to make it HADDOCK-ready"""

    # Loops
    # L chain loops
    l1 = ['26_L', '27_L', '28_L', '29_L', '30_L', '30A_L', '30B_L', '30C_L', '30D_L', '30E_L', '30F_L', '31_L', '32_L']
    l2 = ['50_L', '50A_L', '50B_L', '50C_L', '50D_L', '50E_L', '50F_L', '51_L', '52_L']
    l3 = ['91_L', '92_L', '93_L', '94_L', '95_L', '95A_L', '95B_L', '95C_L', '95D_L', '95E_L', '95F_L', '96_L']
    loops_l = l1 + l2 + l3

    # H chain loops
    h1 = ['26_H', '27_H', '28_H', '29_H', '30_H', '31_H', '31A_H', '31B_H', '31C_H', '31D_H', '31E_H', '31F_H', '32_H']
    h2 = ['52A_H', '52B_H', '52C_H', '52D_H', '52E_H', '52F_H', '53_H', '54_H', '55_H']
    h3 = ['96_H', '97_H', '98_H', '99_H', '100_H', '100A_H', '100B_H', '100C_H', '100D_H', '100E_H', '100F_H', '100G_H',
          '100H_H', '100I_H', '100J_H', '100K_H', '101_H']
    loops_h = h1 + h2 + h3

    def __init__(self, pdbfile, chain):
        """
        Constructor for the AbHaddockFormat class
        Args:
            pdbfile (str): path to the antibody .pdb file
            chain (str): chain id to use for the HADDOCK-ready structure
        """
        self.file = pdbfile
        self.pdb = bp.PandasPdb().read_pdb(self.file)
        self.chain = chain

    def ab_renumb(self, outfile, write=True):
        """
        Renumbers the antibody and extract the HV residues
        If 'write = true' it also writes the new .pdb file

        Args:
            outfile (str): path to the output .pdb file
            write (bool): True writes the output file
            False does not
        Returns:
            hv_list (list): list of the HV residue numbers
            new_pdb: biopandas object containing the HADDOCK-ready pdb
        """

        # Modify resno to include insertions
        resno = self.pdb.df['ATOM']['residue_number'].values
        ins = self.pdb.df['ATOM']['insertion'].values
        chain = self.pdb.df['ATOM']['chain_id'].values
        ch_resno = ['{0}{1}_{2}'.format(i, j, c) for i, j, c in zip(resno, ins, chain)]  # resno including insertions

        # Create new resno
        count = 0
        prev_resid = None
        new_resno = []

        # Renumber
        for r in ch_resno:
            if r != prev_resid:
                count += 1
                new_resno.append(count)
                prev_resid = r
            elif r == prev_resid:
                new_resno.append(count)
                prev_resid = r

        # Update pdb
        new_pdb = cp.deepcopy(self.pdb)
        new_pdb.df['ATOM']['chain_id'] = self.chain
        new_pdb.df['ATOM']['residue_number'] = new_resno
        new_pdb.df['ATOM']['insertion'] = ''  # Remove insertions

        if write:
            new_pdb.to_pdb(path=outfile, records=['ATOM'], append_newline=True)

        # Create data-frame with old and new numbering
        resno_dict = dict(zip(unique(ch_resno), unique(new_resno)))

        # Collect HV residues with the new numbering
        hv_list = []

        # Heavy chain
        for hv_heavy in self.loops_h:
            if hv_heavy in resno_dict.keys():
                hv_list.append(resno_dict[hv_heavy])
            else:
                pass

        # Light chain
        for hv_light in self.loops_l:
            if hv_light in resno_dict.keys():
                hv_list.append(resno_dict[hv_light])
            else:
                pass

        return hv_list, new_pdb


if __name__ == '__main__':

    # Get inputs
    pdb_file, out_file, chain_id = check_input()

    # Renumber pdb file and get HV residues
    pdb_format = AbHaddockFormat(pdb_file, chain_id)
    hv_resno, pdb_ren = pdb_format.ab_renumb(outfile=out_file, write=True)
    print(','.join(map(str, hv_resno)))
