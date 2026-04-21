#!/bin/bash

# =========================
# Generar SMILES + Name + InChI
# =========================

echo "SMILES;Name;InChI" > denovosmHDAC8_1.csv #Renombrar

for f in *.mol2; do
    # SMILES usando nombre del archivo (-xk)
    smiles=$(obabel "$f" -osmi --canonical -xk 2>/dev/null)
    
    # Nombre del archivo sin extensión
    name="${f%.mol2}"
    
    # InChI de la molécula
    inchi=$(obabel "$f" -oinchi 2>/dev/null)

    # Guardar en CSV
    echo "${smiles};${name};${inchi}" >> denovosmHDAC8_1.csv #Renambrar 
done

echo "SMILES + InChI generados en denovosmHDAC8_1.csv"

# =========================
# Generar tabla completa con propiedades de INDEX
# =========================

# Archivo de salida
echo -e "File_ID\tFormula\tMW\tLogP\tpKd\tStructure\tSynthesize\tChemical" > final.tsv

grep -v "^#" INDEX | while IFS= read -r line; do
    # Extraer el path del archivo
    file_path=$(echo "$line" | awk '{print $1}')
    file_id=$(basename "$file_path" .mol2)

    # Propiedades desde INDEX
    formula=$(echo "$line" | awk '{print $2}')
    mw=$(echo "$line" | awk '{print $3}')
    logp=$(echo "$line" | awk '{print $4}')
    pkd=$(echo "$line" | awk '{print $5}')
    struct=$(echo "$line" | awk '{print $6}')
    synth=$(echo "$line" | awk '{print $7}')
    chem=$(echo "$line" | awk '{print $8}')

    # Guardar en TSV
    echo -e "$file_id\t$formula\t$mw\t$logp\t$pkd\t$struct\t$synth\t$chem" >> final.tsv
done

echo "Tabla final generada en final.tsv"

