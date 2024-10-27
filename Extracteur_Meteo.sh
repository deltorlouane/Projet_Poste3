#!/bin/bash

# Vérification de l'argument
if [ -z "$1" ]; then
  echo "Erreur : Veuillez fournir une ville en argument."
  echo "Utilisation : ./Extracteur_Meteo.sh [ville]"
  echo "Exemple : ./Extracteur_Meteo.sh Toulouse"
  exit 1
fi

# Déclaration des variables
VILLE="$1"
FICHIER_METEO="meteo.txt"
FICHIER_ERREUR="meteo_error.log"
DATE=$(date '+%Y-%m-%d')
HEURE=$(date '+%H:%M')

# Récupération des données météo depuis wttr.in et journalisation en cas d'erreur de connexion
if ! curl -s "wttr.in/${VILLE}?format=%t+%f" > meteo_data.txt; then
  echo "${DATE} ${HEURE} - Erreur de connexion à wttr.in pour la ville de $VILLE" >> "$FICHIER_ERREUR"
  exit 1
fi

# Vérification si la ville est inconnue
if grep -q "Unknown location" meteo_data.txt; then
  echo "Erreur : La ville $VILLE est inconnue. Veuillez entrer une autre ville."
  echo "${DATE} ${HEURE} - Ville inconnue : $VILLE" >> "$FICHIER_ERREUR"
  rm meteo_data.txt
  exit 1
fi

# Extraction des températures actuelle et du lendemain
TEMPERATURE_ACTUELLE=$(awk '{print $1}' meteo_data.txt)
TEMPERATURE_DEMAIN=$(awk '{print $2}' meteo_data.txt)

# Validation des données avant enregistrement
if [ -z "$TEMPERATURE_ACTUELLE" ] || [ -z "$TEMPERATURE_DEMAIN" ]; then
  echo "${DATE} ${HEURE} - Données météorologiques non valides pour $VILLE" >> "$FICHIER_ERREUR"
  rm meteo_data.txt
  exit 1
fi

# Enregistrement des données dans meteo.txt
echo "$DATE - $HEURE - $VILLE : Température actuelle : $TEMPERATURE_ACTUELLE - Prévision du lendemain : $TEMPERATURE_DEMAIN" >> "$FICHIER_METEO"
echo "Les données météo de la ville de $VILLE sont enregistrées dans le fichier $FICHIER_METEO."

# Nettoyage du fichier temporaire
rm meteo_data.txt
