#!/usr/bin/env Rscript
# 2019-01-15 16:15:00 Francesco Ambrosetti 
# f.ambrosetti@uu.nl

library(bio3d)
library(optparse)

### Define functions 

consecutive.resno<- function(pdb, chain) {
  
  ### pdb= pdb$atom matrix
  ### chain= chain name
  ### The function returns the chain used as input with a consecutive renumbering
  
  pdb_tmp <- pdb[pdb$chain ==chain,]
  resno_tmp<- unique(pdb_tmp$resno)
  range_tmp<- 1:length(resno_tmp)
  a<- cbind(resno_tmp,range_tmp)
  newNumbering_tmp<- as.numeric(unlist(apply(a,1, function(x) rep(x[2],dim(pdb_tmp[pdb_tmp$resno== x[1],])[1])))) 
  
  pdb_tmp$resno<-newNumbering_tmp
  
  return(pdb_tmp)
}

pdb_format<-function(x, name) {
  
  matri<-x[,9:11]
  coord<-as.vector(apply(matri, 1, function(x) list=c(x[1], x[2], x[3])))
  x$insert<- NA
  write.pdb(xyz =coord, type=as.character(x$type), resno=as.character(x$resno), resid=as.character(x$resid), eleno=as.character(x$eleno), elety=as.character(x$elety), chain=as.character(x$chain), insert=as.character(x$insert), file=name)

}

match.pdbs<- function(pdb1, pdb2,chain) {
  
  print("Matching structures")
  
  ### Modify Resno of the structures to deal with insertions
  #pdb1
  pdb1$atom[is.na(pdb1$atom$insert), "insert"]<- ""
  pdb1$atom$resno<- paste0(pdb1$atom$resno, pdb1$atom$insert, "_", pdb1$atom$chain)  
  
  #pdb2
  pdb2$atom[is.na(pdb2$atom$insert), "insert"]<- ""
  pdb2$atom$resno<- paste0(pdb2$atom$resno, pdb2$atom$insert, "_", pdb2$atom$chain)  
  
  ### Get matching residues
  aln<- pdbaln(list(pdb1, pdb2))
  
  # Remove not aligned residues from both molecules
  noGap_resno<- aln$resno[ ,!is.na(aln$resno[1,]) & !is.na(aln$resno[2,])] 
  
  # Check wheather there are point mutations/different residue types is some positions
  noGap_resid<- aln$resid[ ,!is.na(aln$resid[1,]) & !is.na(aln$resid[2,])] 
  noGap<- noGap_resno[ ,noGap_resid[1,] == noGap_resid[2,]] # <--Keep only the same residues. Remove point mutations/residues which are different
  
  noGap_pdb1_resno<- noGap[1,]
  noGap_pdb2_resno<- noGap[2,]
  
  ### Extract matched resno for pdb1
  matched_pdb1<- pdb1$atom[pdb1$atom$resno %in% noGap_pdb1_resno,]
  
  #Assign correct chain id
  old_resno_1<- unique(matched_pdb1$resno)
  matched_pdb1$chain<- chain
  
  # Renumber 
  matched_pdb1<- consecutive.resno(matched_pdb1, chain)
  new_resno_1<- unique(matched_pdb1$resno)
  
  # Dictionary-matched residues
  dic_pdb1<- data.frame(Old= old_resno_1, Matched= new_resno_1)
  write.csv(dic_pdb1, file = './Resno-pdb1.csv', quote = F, row.names = F)
  
  ### Extract matched resno for receptor
  matched_pdb2<- pdb2$atom[pdb2$atom$resno %in% noGap_pdb2_resno,]
  
  # Assign chain id
  old_resno_2<- unique(matched_pdb2$resno)
  matched_pdb2$chain<- chain
  
  # Renumber
  matched_pdb2<- consecutive.resno(matched_pdb2, chain)
  new_resno_2<- unique(matched_pdb2$resno)
  
  # Dictionary-matched residues
  dic_pdb2<- data.frame(Old= old_resno_2, Matched= new_resno_2)
  write.csv(dic_pdb2, file = './Resno-pdb2.csv',quote = F, row.names = F)
  
  ### Write matching structures 
  pdb_format(matched_pdb1, "./pdb1-matched.pdb") # pdb1
  pdb_format(matched_pdb2,"./pdb2-matched.pdb") # pdb2

  print('DONE!', quote = F)
  
}



#### Run code

option_list <- list(
  make_option(c("-f", "--pdb1"), type="character", default=NULL, 
              help="First .pdb file to be matched", metavar="character"),
  make_option(c("-s", "--pdb2"), type="character", default=NULL, 
              help="Second .pdb file to be matched", metavar="character"),
  make_option(c("-c", "--chain"), type="character", default=NULL, 
              help="Chain id to use for the matched structures", metavar="character")
)


opt_parser <- OptionParser(option_list=option_list, description='This script given 2 pdbs, matches them in order to have a consisten residue numbering.\nOutput files are written in ./pdb1-matched.pdb and ./pdb2-matched.pdb')

opt <-  parse_args(opt_parser)

if (is.null(opt$pdb1) | is.null(opt$pdb2) | is.null(opt$chain)) {
  print_help(opt_parser)
  stop("At least three arguments must be supplied. Type -h for further details.\n", call.=FALSE)
}


### Get files
a<- opt$pdb1
b<- opt$pdb2
chain_id<- opt$chain

### Read pdb files
pdb1<- read.pdb(a, verbose = F)
pdb2<- read.pdb(b, verbose = F)

### Match structures
match.pdbs(pdb1, pdb2,chain_id)











