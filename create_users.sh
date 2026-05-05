#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]
then
  echo "Du måste vara root för detta!"
  exit 1
fi

# Validera argument (minst ett användarnamn skickats in)
if [ $# -eq 0 ]
then
  echo "Du glömde skriva namn. Ange ./create_users.sh namn1 namn2"
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

  # 1. Hämta listan över befintliga användare INNAN den nya skapas
  existing_users=$(cut -d: -f1 /etc/passwd)

  # 2. Skapa användaren
  useradd -m "$namn"

  # 3. Skapa mappar 
  mkdir -p "/home/$namn/Documents" "/home/$namn/Downloads" "/home/$namn/Work"

  # 4. Sätt rättigheter (Endast ägaren)
  chmod 700 "/home/$namn/Documents" "/home/$namn/Downloads" "/home/$namn/Work"

  # 5. Skapa välkomstfilen
  echo "Välkommen $namn" > "/home/$namn/welcome.txt"
  echo "$existing_users" >> "/home/$namn/welcome.txt"
  
  # 6. Ge användaren ägarskap över sin hemkatalog
  chown -R "$namn:$namn" "/home/$namn"

  echo "$namn är klar!"
done