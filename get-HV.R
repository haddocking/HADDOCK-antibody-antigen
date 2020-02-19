#!/usr/bin/env Rscript
# 2019-01-15 16:15:00 Francesco Ambrosetti 
# f.ambrosetti@uu.nl

library(optparse)

### Define loops according to chothia numbering scheme 
#L chain loops
L1<- c('26','27', '28', '29', '30', '30A', '30B', '30C', '30D', '30E', '30F', '31', '32')
L2<- c('50','50A', '50B', '50C', '50D', '50E', '50F', '51', '52')
L3<- c('91','92', '93', '94', '95', '95A', '95B', '95C', '95D', '95E', '95F', '96')
loops_L<- paste0(c(L1,L2,L3),'_L')

#H chain loops
H1<- c('26','27', '28', '29', '30', '31','31A', '31B', '31C', '31D', '31E', '31F', '32')
H2<- c('52A', '52B', '52C', '52D', '52E', '52F','53', '54', '55')
H3<- c('96','97', '98', '99', '100', '100A', '100B', '100C', '100D', '100E', '100F', '100G', '100H', '100I', '100J', '100K', '101')
loops_H<- paste0(c(H1,H2,H3), '_H')


#### Run code
### Collect argument
option_list <- list(
  make_option(c("-i", '--input'), type="character", default=NULL, 
              help="Path to the .csv file obtained running match_numbering.R", metavar="character"))

opt_parser <- OptionParser(option_list=option_list, 
                           description='This script extracts the number of the residues belonging to the HV loops')

opt <-  parse_args(opt_parser)

if (is.null(opt$input)) {
  print_help(opt_parser)
  stop("At least one argument must be supplied. Type -h for further details.\n", call.=FALSE)
}

### Read input files
resno<- read.csv(opt$input, stringsAsFactors = F)

### Get HV loops
# Heavy chain
hv_h<- resno[resno$Old %in% loops_H, "Matched"]

# Light chain
hv_l<- resno[resno$Old %in% loops_L, "Matched"]

### Output
out<- paste(sort(c(hv_h, hv_l)), collapse = ',')
cat(out, "\n")