#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=12:00:00
#SBATCH --mem=22GB
#SBATCH --output=/dev/null
use_scratch=false

input_files="*.com"

#=============================#

module purge

GILLIARDLAB=/home/gridsan/groups/gilliardlab
export g16root=$GILLIARDLAB/opt/chemistry/Gaussian16_A03
export GAUSS_EXEDIR=$g16root/g16
export GAUSS_SCRDIR=$g16root/scr
NBOEXE=$GILLIARDLAB/opt/chemistry/NBO6/bin/nbo6.i4.exe

JOBDIR="$PWD"
export JOBDIR
export PATH=$JOBDIR:$PATH

for file in $input_files; do
    job_name=${file//.com/}
    input_file=${job_name}.com
    output_file=${job_name}.log
    if [ "$use_scratch" = true ]; then
        export SCRATCHDIR=$HOME/scratch
        export PATH=$SCRATCHDIR:$PATH
        export GAUSSTEMPDIR=$SCRATCHDIR
        if [ ! -d "$GAUSSTEMPDIR/${job_name}"_tmp ]; then
            mkdir -p "$GAUSSTEMPDIR/${job_name}"_tmp
            export TEMPDIR=$GAUSSTEMPDIR/${job_name}_tmp
        else
            num_dirs=$(find "$GAUSSTEMPDIR" -name "*${job_name}_tmp*" | wc -l)
            if [ "$num_dirs" -lt 10 ]; then
                mkdir -p "$GAUSSTEMPDIR/${job_name}_tmp_0$num_dirs"
                export TEMPDIR=$GAUSSTEMPDIR/${job_name}_tmp_0${num_dirs}
            else
                mkdir -p "$GAUSSTEMPDIR/${job_name}_tmp_$num_dirs"
                export TEMPDIR=$GAUSSTEMPDIR/${job_name}_tmp_${num_dirs}
            fi
        fi
        cp "$input_file" "$TEMPDIR"
        cd "$TEMPDIR" || exit
        "$GAUSS_EXEDIR"/g16 "$input_file" >& "$output_file" 2>&1
        cp "$TEMPDIR/$output_file" "$JOBDIR"/
        cp -r "$TEMPDIR"/ "$JOBDIR"/
        rm -r "${TEMPDIR:?}/"
        cd "$JOBDIR" || exit
    else
        export GAUSSTEMPDIR=$JOBDIR
        mkdir -p "$GAUSSTEMPDIR"/"${job_name}"_tmp
        export TEMPDIR=$GAUSSTEMPDIR/${job_name}_tmp
        cp "$input_file" "$TEMPDIR"
        cd "$TEMPDIR" || exit
        "$GAUSS_EXEDIR"/g16 "$input_file" >& "$output_file" 2>&1
        cp "$TEMPDIR"/"$output_file" "$JOBDIR"/
        cd "$JOBDIR" || exit
    fi
done
