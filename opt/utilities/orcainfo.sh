#!/bin/bash

usage() {
    echo "Usage: parser.sh -o <output_file>"
    exit 1
}

while getopts ":o:l:" opt; do
    case $opt in
        o)
            output=$OPTARG
            echo "output file: $output" >&2
            ;;
        l)
            extended=$OPTARG
            echo "Extended output: $extended" >&2
            ;;
        \?)
            echo "Error: Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Error: Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

if [ $OPTIND -eq 1 ]; then
    echo "No options were passed"
    usage
fi

shift $((OPTIND -1))

echo "============================================="
if grep -q "THE OPTIMIZATION HAS CONVERGED" "$output"; then
    echo "The optimization has converged"
else
    echo "The optimization has not converged or has failed"
fi

# grep for imaginary mode if found print warning in red color
if grep -q "imaginary mode" "$output"; then
    echo -e "\e[31mWarning: Imaginary mode found\e[0m"
else
    echo "No imaginary modes found"
fi

# multiplicity=$(grep "Multiplicity           Mult            ....    1" "$output" | awk '{print $NF}')

echo "============================================="

number_of_electrons=$(grep -m 1 "Number of Electrons" "$output" | awk '{print $6}')
if [ $((number_of_electrons % 2)) -eq 0 ]; then
    homo_molecular_orbital_number=$(echo "scale=0; ($number_of_electrons/2)-1" | bc)
    homo_energy=$(grep -w "$homo_molecular_orbital_number   2.0000" "$output" | tail -n 1 | awk '{print $4}')
    lumo_molecular_orbital_number=$((homo_molecular_orbital_number + 1))
    lumo_energy=$(grep -w "$lumo_molecular_orbital_number   0.0000" "$output" | tail -n 1 | awk '{print $4}')
    homo_lumo_gap=$(echo "$lumo_energy - $homo_energy" | bc)
    echo -e "HOMO-LUMO Gap = ${homo_lumo_gap} eV"
else
    echo "HOMO-LUMO gap only valid for closed-shell calculations"
fi

electronic_energy=$(grep "Electronic energy" "$output" | awk '{print $4}')
zero_point_energy=$(grep "Zero point energy" "$output" | awk '{print $5}')
total_enthalpy=$(grep "Total Enthalpy" "$output" | awk '{print $4}')
enthalpy_correction=$(echo "$total_enthalpy - $electronic_energy" | bc)
enthalpy_correction=$(awk '/Electronic energy/ {e=$4} /Total Enthalpy/ {t=$4} END {printf "%0.8f", t-e}' "$output")
entropy_correction=$(grep "Total entropy correction" "$output" | awk '{print $5}')
gibbs_free_energy_correction=$(grep "G-E(el)" "$output" | awk '{print $3}')

echo "============================================="
printf "Electronic Energy  : %.6f Eh\n" "$electronic_energy"
printf "Zero Point Energy  :    %.6f Eh\n" "$zero_point_energy"
printf "Enthalpy Correction:    %.6f Eh\n" "$enthalpy_correction"
enthalpy_correction=$(awk '/Electronic energy/ {e=$4} /Total Enthalpy/ {t=$4} END {printf "%0.8f", t-e}' "$output")
printf "Entropy Correction :   %.6f Eh\n" "$entropy_correction"
printf "Gibbs Correction   :    %.6f Eh\n" "$gibbs_free_energy_correction"
echo "============================================="

runtime=$(grep "TOTAL RUN TIME" "$output" | awk '{printf "%s %s %s %s %s %s %s %s", $4, $5, $6, $7, $8, $9, $10, $11}')
echo "Run Time: $runtime"
echo "============================================="
