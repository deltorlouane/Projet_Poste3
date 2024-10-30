#!/bin/bash

#Suppression anciens fichiers meteo
rm meteo_2024*.txt

# Déclaration des variables
VILLE="${1:-Toulouse}"
DATE=$(date '+%Y-%m-%d')
HEURE=$(date '+%H:%M')
FICHIER_METEO="meteo_${VILLE}_${DATE}_${HEURE}.json"
FICHIER_RESULTAT="meteo_$(date '+%Y%m%d').txt"
FICHIER_METEO_JSON="meteo_$(date '+%Y%m%d').json"

# Récupération des données météo
if ! curl -s "wttr.in/$VILLE?format=j1" -o "$FICHIER_METEO"; then
  echo "Erreur : Impossible de se connecter à wttr.in pour la ville de $VILLE."
  echo "Veuillez vérifier votre connexion Internet ou l'orthographe de la ville."
  rm -f "$FICHIER_METEO"
  exit 1
fi

# Vérification si la ville est inconnue ou si le fichier est vide
if grep -q "Unknown location" "$FICHIER_METEO" || [ ! -s "$FICHIER_METEO" ]; then
  echo "Erreur : La ville $VILLE est inconnue ou les données sont manquantes. Veuillez entrer une autre ville."
  rm -f "$FICHIER_METEO"
  exit 1
fi

# Extraction des informations météo
TEMPERATURE_ACTUELLE=$(jq -r '.current_condition[0].temp_C' "$FICHIER_METEO")
TEMPERATURE_DEMAIN=$(jq -r '.weather[1].maxtempC' "$FICHIER_METEO")
VITESSE_VENT=$(jq -r '.current_condition[0].windspeedKmph' "$FICHIER_METEO")
HUMIDITE=$(jq -r '.current_condition[0].humidity' "$FICHIER_METEO")
VISIBILITE=$(jq -r '.current_condition[0].visibility' "$FICHIER_METEO")

# Vérification des données extraites
if [ -z "$TEMPERATURE_ACTUELLE" ] || [ -z "$TEMPERATURE_DEMAIN" ] || [ -z "$VITESSE_VENT" ] || [ -z "$HUMIDITE" ] || [ -z "$VISIBILITE" ]; then
  echo "Erreur : Données météorologiques non valides pour la ville de $VILLE."
  rm -f "$FICHIER_METEO"
  exit 1
fi

# Enregistrement des informations météo dans le fichier résultat
echo "$DATE - $HEURE - $VILLE : Température actuelle : ${TEMPERATURE_ACTUELLE}°C - Prévision du lendemain : ${TEMPERATURE_DEMAIN}°C - Vent : ${VITESSE_VENT} km/h - Humidité : ${HUMIDITE}% - Visibilité : ${VISIBILITE} km" >> "$FICHIER_RESULTAT"
echo "Les informations météo ont été enregistrées dans $FICHIER_RESULTAT."

# Nettoyage du fichier temporaire
rm -f "$FICHIER_METEO"

