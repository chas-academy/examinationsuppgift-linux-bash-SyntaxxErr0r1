#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]
then
  echo "Du måste vara root för detta!"
  exit 1
fi

# Här börjar loopen för alla argument
for namn in "$@"
do
  echo "Nu fixar vi användaren: $namn"

  # skapa användaren med hemkatalog
  useradd -m "$namn"

  # skapa undermappar i hemkatalogen

  mkdir -p "/home/$namn/Documents" "/home/$namn/Downloads" "/home/$namn/Work"

  # 4. Sätt rättigheter (Endast ägaren)
  chmod 700 "/home/$namn/Documents" "/home/$namn/Downloads" "/home/$namn/Work"

  # 5. Skapa välkomstfilen
  echo "Välkommen $namn" > "/home/$namn/welcome.txt"
 
  #Lägg till en lista på alla andra användare

  echo "Andra användare:" >> "/home/$namn/welcome.txt"
  cut -d: -f1 /etc/passwd >> "/home/$namn/welcome.txt"

  # Ge användaren ägarskap över sin hemkatalog
  chown -R "$namn" "/home/$namn"

  done

  echo "allt är klart!"