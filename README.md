README Projet Poste 3

#Configuration d'une tâche Cron
#Pour automatiser la collecte des données météo, vous pouvez utiliser une tâche cron.
#Voici les étapes :

#Ouvrez l’éditeur de tâches cron avec cette commande : crontab -e

#Modifiez ce fichier pour introduire les tâches à exécuter par cron.
#Chaque tâche à exécuter doit être définie par une seule ligne indiquant avec différents champs quand la tâche sera exécutée et quelle commande exécuter pour la tâche.
#Pour définir l'heure, vous pouvez fournir des valeurs concrètes pour minute (m), heure (h), jour du mois (dom), mois (mon) et jour de la #semaine (dow), ou utiliser '*' dans ces champs.
#Veuillez noter que les tâches seront lancées en fonction de la notion de temps et de fuseaux horaires du système de cron.
#Par exemple, vous pouvez automatiser l’exécution du script météo à des intervalles réguliers, comme au début de chaque heure :
0 * * * * /Extracteur_Meteo.sh >> /meteo.log 2>&1
#Cette tâche exécutera le script périodiquement pour collecter les données météo sans intervention manuelle.

#Sauvegarder et quitter : Enregistrez les modifications et fermez l’éditeur crontab.
#La tâche cron est maintenant configurée et le script s’exécutera automatiquement selon l’intervalle défini.
