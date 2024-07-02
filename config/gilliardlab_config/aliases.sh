#!/bin/bash

GILLIARDLAB=/home/gridsan/groups/gilliardlab

# Group Aliases
alias stream='less -S +F'
alias jobstat='$GILLIARDLAB/opt/utilities/jobstat.sh'
alias submit='$GILLIARDLAB/opt/utilities/submit.sh'

rename() {
    local from=$1
    local to=$2
    shift 2
    local files="$@"

    for file in $files; do
        $GILLIARDLAB/opt/utilities/rename.pl "s/$from/$to/" "$file"
    done
}

### ORCA 5.0.4
alias copyorca='cp $GILLIARDLAB/opt/utilities/slurm_scripts/slurm_orca504.sh'
alias conv='egrep --color "YES|      NO|GEOMETRY OPTIMIZATION CYCLE|HURRAY|THE OPTIMIZATION HAS CONVERGED|ORCA TERMINATED NORMALLY|ORCA finihed with error|Optimization Cycle: |N\(occ\)="'

### Gaussian 16
alias copyg16='cp $GILLIARDLAB/opt/utilities/slurm_scripts/slurm_gaussian16.sh'

### Crest 3.0.1
alias copycrest='cp $GILLIARDLAB/opt/utilities/slurm_scripts/slurm_crest301.sh'

### GIMIC 2.2.1
alias copygimic='cp $GILLIARDLAB/opt/utilities/slurm_scripts/slurm_gimic221.sh'
