#!/bin/bash

# Définir une ville par défaut (ici Toulouse) si aucun argument n'est fourni
VILLE_PAR_DEFAUT="Toulouse"

# Vérification de l'argument
if [ -z "$1" ]; then
  echo "Aucune ville n'a été fournie, utilisation de la ville par défaut: $VILLE_PAR_DEFAUT"
  VILLE="$VILLE_PAR_DEFAUT"
else
  VILLE="$1"
fi

# Déclaration des variables
DATE=$(date '+%Y-%m-%d')
HEURE=$(date '+%H:%M')
FICHIER_METEO="meteo_${VILLE}_${DATE}_${HEURE}.json"
FICHIER_RESULTAT="meteo.txt"

# Récupérer les données météo
if ! curl -s "wttr.in/$VILLE?format=j1" -o "$FICHIER_METEO"; then
  echo "Erreur : Impossible de se connecter à wttr.in pour la ville de $VILLE."
  echo "Veuillez vérifier votre connexion Internet ou l'orthographe de la ville."
  rm -f "$FICHIER_METEO"
  exit 1
fi

# Vérifier si la ville est inconnue ou si le fichier est vide
if grep -q "Unknown location" "$FICHIER_METEO" || [ ! -s "$FICHIER_METEO" ]; then
  echo "Erreur : La ville $VILLE est inconnue ou les données sont manquantes. Veuillez entrer une autre ville."
  rm -f "$FICHIER_METEO"
  exit 1
fi

# Extraire les informations météo
TEMPERATURE_ACTUELLE=$(jq -r '.current_condition[0].temp_C' "$FICHIER_METEO")
TEMPERATURE_DEMAIN=$(jq -r '.weather[1].maxtempC' "$FICHIER_METEO")

# Vérification des données extraites
if [ -z "$TEMPERATURE_ACTUELLE" ] || [ -z "$TEMPERATURE_DEMAIN" ]; then
  echo "Erreur : Données météorologiques non valides pour la ville de $VILLE."
  rm -f "$FICHIER_METEO"
  exit 1
fi

# Écrire les informations météo dans le fichier résultat
echo "$DATE - $HEURE - $VILLE : Température actuelle : ${TEMPERATURE_ACTUELLE}°C - Prévision du lendemain : ${TEMPERATURE_DEMAIN}°C" >> "$FICHIER_RESULTAT"
echo "Les informations météo ont été enregistrées dans $FICHIER_RESULTAT."

# Nettoyage du fichier temporaire
rm -f "$FICHIER_METEO"
