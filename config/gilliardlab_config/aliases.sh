export GILLIARDLAB=/home/gridsan/groups/gilliardlab

# Group Aliases
alias stream='less -S +F'
alias jobstat='$GILLIARDLAB/opt/utilities/jobstat.sh'
alias submit='$GILLIARDLAB/opt/utilities/slurm_scripts/submit.sh'

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

### Gaussian 16
alias copyg16='cp $GILLIARDLAB/opt/utilities/slurm_scripts/slurm_gaussian16.sh'
