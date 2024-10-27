#!/bin/bash

if [ -z "$1" ]; then
  echo "Erreur : Veuillez fournir une ville en argument."
  echo "Utilisation : ./Extracteur_Meteo.sh [ville]"
  echo "Exemple : ./Extracteur_Meteo.sh Toulouse"
  exit 1
fi

VILLE="$1"
FICHIER_METEO="meteo.txt"
FICHIER_ERREUR="meteo_error.log"
DATE=$(date '+%Y-%m-%d')
HEURE=$(date '+%H:%M')

if ! curl -s "wttr.in/${VILLE}?format=%t+%f" > meteo_data.txt; then
  echo "${DATE} ${HEURE} - Erreur de connexion à wttr.in pour la ville de $VILLE" >> "$FICHIER_ERREUR"
  exit 1
fi

if grep -q "Unknown location" meteo_data.txt; then
  echo "Erreur : La ville $VILLE est inconnue. Veuillez entrer une autre ville."
  echo "${DATE} ${HEURE} - Ville inconnue : $VILLE" >> "$FICHIER_ERREUR"
  rm meteo_data.txt
  exit 1
fi

TEMPERATURE_ACTUELLE=$(awk '{print $1}' meteo_data.txt)
TEMPERATURE_DEMAIN=$(awk '{print $2}' meteo_data.txt)

if [ -z "$TEMPERATURE_ACTUELLE" ] || [ -z "$TEMPERATURE_DEMAIN" ]; then
  echo "${DATE} ${HEURE} - Données météorologiques non valides pour $VILLE" >> "$FICHIER_ERREUR"
  rm meteo_data.txt
  exit 1
fi

echo "$DATE - $HEURE - $VILLE : Température actuelle : $TEMPERATURE_ACTUELLE - Prévision du lendemain : $TEMPERATURE_DEMAIN" >> "$FICHIER_METEO"
echo "Les données météo de la ville de $VILLE sont enregistrées dans le fichier $FICHIER_METEO."

rm meteo_data.txt
