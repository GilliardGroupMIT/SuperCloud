export GILLIARDGRP=$HOME/gilliardlab_shared

### ORCA 5.0.4
export ORCA_PATH=$HOME/gilliardlab_shared/opt/chemistry/Orca_504
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/gilliardlab_shared/opt/chemistry/Orca_504
export PATH=$PATH:$ORCA_PATH

### Gaussian16
export g16root=$GILLIARDGRP/opt/chemistry/Gaussian16_A03/
export GAUSS_EXEDIR=$g16root/g16
export GAUSS_SCRDIR=$g16root/scr
export PATH=$PATH:$GAUSS_EXEDIR
