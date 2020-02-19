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


haddock.format<- function(pdb, outfile, chain) {
  
  print("Formatting structure")
  
  ### Modify Resno of the structure to deal with insertions
  pdb$atom[is.na(pdb$atom$insert), "insert"]<- ""
  pdb$atom$resno<- paste0(pdb$atom$resno, pdb$atom$insert, "_", pdb$atom$chain)  
  old_resno<- unique(pdb$atom$resno)
  
  ### Renumber
  pdb$atom$chain<- chain # Assign correct chain id
  formatted_pdb<- consecutive.resno(pdb$atom, chain)
  new_resno<- unique(formatted_pdb$resno)
  
  ### Write HADDOCK-ready structure 
  pdb_format(formatted_pdb, outfile)
  
  ### Dictionary-formatted residues
  dic_pdb<- data.frame(Old= old_resno, Matched= new_resno)
  dic_name<- paste0(basename.pdb(outfile), '.csv')
  write.csv(dic_pdb, file = dic_name, quote = F, row.names = F)
  
  print('Complete!', quote = F)
  
}

#### Run code

option_list <- list(
  make_option(c("-i", "--pdb"), type="character", default=NULL, 
              help="Path to the .pdb file to be formatted for HADDOCK", metavar="character"),
  make_option(c("-o", "--out"), type="character", default=NULL, 
              help="Path to the output file", metavar="character"),
  make_option(c("-c", "--chain"), type="character", default=NULL, 
              help="Chain id to use for the HADDOCK-formatted structure", metavar="character")
)

opt_parser <- OptionParser(option_list=option_list, description='This script given a pdb file it formats it in order to be HADDOCK-ready.\nThe output consists of a pdb file HADDOCK-ready and of a .csv file\nwhere the renumbered residues are mapped to the old ones\n\nUSAGE example:\n./HADDOCK-format.R -i 4G6K_ch.pdb -o 4G6K-HADDOCK.pdb -c A')

opt <-  parse_args(opt_parser)

if (is.null(opt$pdb) | is.null(opt$out) | is.null(opt$chain)) {
  print_help(opt_parser)
  stop("At least three arguments must be supplied. Type -h for further details.\n", call.=FALSE)
}


### Get files
a<- opt$pdb
out<- opt$out
chain_id<- opt$chain

### Read pdb files
pdb<- read.pdb(a, verbose = F)

### Format pdb
haddock.format(pdb = pdb, outfile = out, chain = chain_id)


