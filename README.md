# cal_pve_se_via_delta
Calculate PVE standard error via delta method

Sometimes, we need to calculate proportion of variance explained (PVE) and its standard error (SE) based variance estimation on hand. Generally, the delta method is used. Here is a Perl script to implement the delta method.

The Perl script uses as input an MMAP (https://mmap.github.io/) output file for variance component estimation. If the MMAP file is not available, one can also create a CSV file for use as long as it contains lines of variance estimates and lines of (co)variance between variance estimates. 

Example CSV file (ex.varcomp.csv):  
G_VAR,8.920951  
ERROR_VAR,1136.201216  
COV_G_G,10.926874  
COV_ERROR_G,2.209236  
COV_ERROR_ERROR,118.568153  

Command line:  
```
perl cal_pve_se_via_delta.pl ex.varcomp.csv G ERROR
```

## Usage  
At least 3 arguments needed:  
&nbsp;&nbsp;MMAP .variance.components.T.csv file  
&nbsp;&nbsp;>=2 VarComp names  
Example: 
```
perl cal_pve_se_via_delta.pl test.variance.components.T.csv G D I ERROR
```

The sum of all specified variance components is used as total. 

## Contact
Jicai Jiang (jicai_jiang AT ncsu DOT edu)
