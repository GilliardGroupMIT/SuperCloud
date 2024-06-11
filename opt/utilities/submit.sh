#!/bin/bash

files=$(ls -1 | grep -c inp)

if [ ! -f slurm_master ]; then
    echo "WARNING: SLURM master file does not exist - Using 24Hr SLURM template"
    for SLURMJOB in $(seq 1 "$files"); do
        if [[ "$SLURMJOB" -lt 10 ]]; then
            cp -v "$HOME"/gilliardlab_shared/opt/utilities/slurm_scripts/slurm_orca504.sh slurm_0"$SLURMJOB"
            sed -i "s/*.inp/0${SLURMJOB}*.inp/" slurm_0"$SLURMJOB"
            sbatch slurm_0"$SLURMJOB"
        else
            cp -v "$HOME"/gilliardlab_shared/opt/utilities/slurm_scripts/slurm_orca504.sh slurm_"$SLURMJOB"
            sed -i "s/*.inp/${SLURMJOB}*.inp/" slurm_"$SLURMJOB"
            sbatch slurm_"$SLURMJOB"
        fi
    done
else
    for SLURMJOB in $(seq 1 "$files"); do
        if [[ "$SLURMJOB" -lt 10 ]]; then
            cp -v slurm_master slurm_0"$SLURMJOB"
            sed -i "s/*.inp/0${SLURMJOB}*.inp/" slurm_0"$SLURMJOB"
            sbatch slurm_0"$SLURMJOB"
        else
            cp -v slurm_master slurm_"$SLURMJOB"
            sed -i "s/*.inp/${SLURMJOB}*.inp/" slurm_"$SLURMJOB"
            sbatch slurm_"$SLURMJOB"
        fi
    done
fi
