#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]
then
  echo "Du måste vara root för detta!"
  exit 1
fi

# kontrollera att minst ett argument skickas med
if [ $# -eq 0 ]; then
echo "Du glömde skriva namn. Ange .create_users.sh namn1 namn2"
exit 1
fi

# Här börjar loopen för alla argument
for namn in "$@"; do
  echo "nu fixar vi användaren: $namn"

  # skapa användaren med hemkatalog
  useradd -m "$namn"

  # skapa undermappar i hemkatalogen

  mkdir -p "/home/$namn/Documents" "/home/$namn/Downloads" "/home/$namn/Work"

  # Sätt rättigheter (Endast ägaren)
  chmod 700 "/home/$namn/Documents" "/home/$namn/Downloads" "/home/$namn/Work"

  #  Skapa välkomstfilen
  echo "Välkommen $namn" > "/home/$namn/welcome.txt"
 
  for user in "$@"; do
    if [ "$user" != "$namn" ]; then
      echo "$user" >> "/home/$namn/welcome.txt"
    fi
  done

  # Ge användaren ägarskap över sin hemkatalog
  chown -R "$namn":"$namn" "/home/$namn"
done

  echo "allt är klart!"
