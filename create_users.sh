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

  # kontrollera om användaren redan finns
  if id "$namn" &>/dev/null; then
    echo "Användaren $namn finns redan, Hoppa över."
    continue
  fi

  # Skapa systemanvändare och home directory
  useradd -m "$namn"

  # skapa de tre mapparna
  mkdir -p "/home/$namn/Documents"
  mkdir -p "/home/$namn/Downloads"
  mkdir -p "/home/$namn/Work"

  # sätt rättigheter: full åtkomst för ägaren, blockera grupp och övriga
  chmod 700 "/home/$namn/Documents"
  chmod 700 "/home/$namn/Downloads"
  chmod 700 "/home/$namn/Work"

  # Skapa välkkomstfilen
  echo "Välkommen $namn" > "/home/$namn/welcome.txt"
  echo "Här är alla andra användare:" >> "/home/$namn/welcome.txt"

  # Hämta listan på alla användare (enklaste sättet)
  cut -d: -f1 /etc/passwd | grep -v "^$namn$" >> "/home/$namn/welcome.txt"

  # Ge användaren ägarskap överallt
  chown -R "$namn:$namn" "/home/$namn"

  echo "$namn är klar!"
done

echo "klar med alla!"
