#!/bin/bash

GILLIARDLAB=/home/gridsan/groups/gilliardlab

export LS_COLORS=$LS_COLORS:'*.inp=0;33:*.out=0;31:*.run=0;33:*.log=0;31:*.xyz=0;35:*trj.xyz=0;0:*scfgrad.inp=0;0:*.res.*=0;36'
export CLICOLOR=1

export PATH=$PATH:GILLIARDLAB/.local/bin

### ORCA 5.0.4
export ORCA_PATH=$GILLIARDLAB/opt/chemistry/Orca_504
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$GILLIARDLAB/opt/chemistry/Orca_504
export PATH=$PATH:$ORCA_PATH

### Gaussian16
export g16root=$GILLIARDLAB/opt/chemistry/Gaussian16_A03
export GAUSS_EXEDIR=$g16root/g16
export GAUSS_SCRDIR=$g16root/scr
export PATH=$PATH:$GAUSS_EXEDIR

### Crest 3.0.1
export PATH=$PATH:$GILLIARDLAB/opt/chemistry/crest_301

### NBO6
export NBOEXE=$GILLIARDLAB/opt/chemistry/NBO6/bin/nbo6.i4.exe
