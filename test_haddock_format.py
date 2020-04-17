#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright 2020:
#   Francesco Ambrosetti
#

import ab_haddock_format as hf
import biopandas.pdb as bp
import unittest


class TestHf(unittest.TestCase):

    """Create testing class"""

    pdbfile = 'Test_data/4G6K_ch.pdb'
    chain_id = 'A'

    golden_hv = [26, 27, 28, 29, 30, 31, 32, 33, 34, 55, 56, 57, 101, 102, 103, 104, 105,
                 106, 107, 108, 146, 147, 148, 149, 150, 151, 152, 170, 171, 172, 211,
                 212, 213, 214, 215, 216]
    golden_pdb = bp.PandasPdb().read_pdb('Test_data/haddock-ready.pdb')
    golden_resi = golden_pdb.df['ATOM']['residue_number'].to_list()

    def test_ab_format(self):

        hd_format = hf.AbHaddockFormat(self.pdbfile, self.chain_id)
        hv_resno, pdb_ren = hd_format.ab_format()

        self.assertEqual(self.golden_hv, hv_resno, "HV residues are different\n")

        resi_numb = pdb_ren.df['ATOM']['residue_number'].to_list()
        self.assertEqual(self.golden_resi, resi_numb, "Residue number is different\n")


if __name__ == '__main__':
    unittest.main()
