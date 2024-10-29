#!/bin/bash

if [ -z "$1" ]; then
  echo "Erreur : Veuillez fournir une ville en argument."
  echo "Utilisation : ./Extracteur_Meteo.sh <ville>"
  echo "Exemple : ./Extracteur_Meteo.sh Toulouse"
  exit 1
fi

VILLE="$1"
DATE=$(date '+%Y-%m-%d')
HEURE=$(date '+%H:%M')
FICHIER_RESULTAT="meteo.txt"

if ! curl -s "wttr.in/${VILLE}?format=%t+%f" > meteo_data.txt; then
  echo "Erreur : Impossible de se connecter à wttr.in pour la ville de $VILLE."
  echo "Veuillez vérifier votre connexion Internet ou l'orthographe de la ville."
  exit 1
fi

if grep -q "Unknown location" meteo_data.txt; then
  echo "Erreur : La ville $VILLE est inconnue ou les données sont manquantes. Veuillez entrer une autre ville."
  rm meteo_data.txt
  exit 1
fi

TEMPERATURE_ACTUELLE=$(awk '{print $1}' meteo_data.txt)
TEMPERATURE_DEMAIN=$(awk '{print $2}' meteo_data.txt)

if [ -z "$TEMPERATURE_ACTUELLE" ] || [ -z "$TEMPERATURE_DEMAIN" ]; then
  echo "Erreur : Données météorologiques non valides pour la ville de $VILLE."
  rm meteo_data.txt
  exit 1
fi

echo "$DATE - $HEURE - $VILLE : Température actuelle : ${TEMPERATURE_ACTUELLE} - Prévision du lendemain : ${TEMPERATURE_DEMAIN}" >> "$FICHIER_RESULTAT"
echo "Les données météo de la ville de $VILLE sont enregistrées dans le fichier $FICHIER_RESULTAT."

rm meteo_data.txt
