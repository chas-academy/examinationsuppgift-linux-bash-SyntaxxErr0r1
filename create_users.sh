#!/bin/bash

# kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]
then
echo "Du måste vara root för detta!"
exit 1
fi

#validera argument (minst ett användarnamn skickats in)
if [ $# -eq 0 ]
then
echo "Du glömde skriva namn. Ange  ./create_users.sh namn1 namn2"
exit 1
fi

# Här börjar loopen för alla namn
for namn in "$@"
do
  echo "Nu fixar vi användaren: $namn"

  # Kontrollera om användaren redan finns
  if id "$namn" &>/dev/null; then
    echo "Användaren $namn finns redan, Hoppa över."
    continue
  fi

  #  Hämta listan över befintliga användare
  existing_users=$(cut -d: -f1 /etc/passwd)

  #  Skapa användaren
  useradd -m "$namn"

  #  Skapa mappar 
  mkdir -p "/home/$namn/Documents" "/home/$namn/Downloads" "/home/$namn/Work"

  #  Sätt rättigheter
  chmod 700 "/home/$namn/Documents" "/home/$namn/Downloads" "/home/$namn/Work"

  #  Skapa välkomstfilen
  echo "Välkommen $namn" > "/home/$namn/welcome.txt"
  echo "$existing_users" >> "/home/$namn/welcome.txt"
  
  #  Ge användaren ägarskap
  chown -R "$namn:$namn" "/home/$namn"

  echo "$namn är klar!"
done
