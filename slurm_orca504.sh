#!/bin/bash

# AUTHOR: Andrew Molino - MIT - Gilliard Group

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=24:00:00
#SBATCH --mem=66GB
use_scratch=true

input_files="*.inp"

module purge
module load mpi/openmpi-4.1.5

ORCA_PATH=$HOME/opt/chemistry/Orca_5.0.4
export NBOEXE=$HOME/opt/chemistry/NBO6/nbo6/bin/nbo6.i4.exe

JOBDIR="$PWD"
export JOBDIR
export PATH=$JOBDIR:$PATH

for file in $input_files; do
    job_name=${file//.inp/}
    input_file=${job_name}.inp
    output_file=${job_name}.out
    if [ "$use_scratch" = true ]; then
        export SCRATCHDIR=$HOME/scratch
        export PATH=$SCRATCHDIR:$PATH
        export ORCATEMPDIR=$SCRATCHDIR
        if [ ! -d "$ORCATEMPDIR/${job_name}"_tmp ]; then
            mkdir -p "$ORCATEMPDIR/${job_name}"_tmp
            export TEMPDIR=$ORCATEMPDIR/${job_name}_tmp
        else
            num_dirs=$(find "$ORCATEMPDIR" -name "*${job_name}_tmp*" | wc -l)
            if [ "$num_dirs" -lt 10 ]; then
                mkdir -p "$ORCATEMPDIR/${job_name}_tmp_0$num_dirs"
                export TEMPDIR=$ORCATEMPDIR/${job_name}_tmp_0${num_dirs}
            else
                mkdir -p "$ORCATEMPDIR/${job_name}_tmp_$num_dirs"
                export TEMPDIR=$ORCATEMPDIR/${job_name}_tmp_${num_dirs}
            fi
        fi
        cp "$input_file" "$TEMPDIR"
        dependencies=$(find "$JOBDIR" -type d -iname "dependencies" -print -quit)
        if [ -n "$dependencies" ]; then
            dependency_errors=$(find "$dependencies" -type f -not -name "${job_name}_D?????.res.*")
            if [ -n "$dependency_errors" ]; then
                echo "Error: Input filename '$input_file' does not match dependency file name(s):"
                exit 1
            else
                find "$dependencies" -type f -name "${job_name}_D?????.res.*" -exec cp {} "$TEMPDIR" \;
            fi
        fi
        cd "$TEMPDIR" || exit
        "$ORCA_PATH"/orca "$input_file" >& "$output_file" 2>&1
        cp "$TEMPDIR/$output_file" "$JOBDIR"/
        cp -r "$TEMPDIR"/ "$JOBDIR"/
        rm -r "${TEMPDIR:?}/"
        cd "$JOBDIR" || exit
    else
        export ORCATEMPDIR=$JOBDIR
        mkdir -p "$ORCATEMPDIR/${job_name}"_tmp
        export TEMPDIR=$ORCATEMPDIR/${job_name}_tmp
        cp "$input_file" "$TEMPDIR"
        dependencies=$(find "$JOBDIR" -type d -iname "dependencies" -print -quit)
        if [ -n "$dependencies" ]; then
            dependency_errors=$(find "$dependencies" -type f -not -name "${job_name}_D?????.res.*")
            if [ -n "$dependency_errors" ]; then
                echo "Error: Input filename '$input_file' does not match dependency file name(s):"
                exit 1
            else
                find "$dependencies" -type f -name "${job_name}_D?????.res.*" -exec cp {} "$TEMPDIR" \;
            fi
        fi
        cd "$TEMPDIR" || exit
        "$ORCA_PATH"/orca "$input_file" >& "$output_file" 2>&1
        cp "$TEMPDIR/$output_file" "$JOBDIR"/
        cd "$JOBDIR" || exit
    fi
done
