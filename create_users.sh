#! /bin/bash

# kolla om man är root
if [ "$EUID" -ne 0 ]
then
echo "Du måste vara root för detta!"
exit 1
fi

#kolla om man skrev in några namn
if [ $# -eq 0 ]
then
echo "Du glömde  skriva namn. Ange  ./create_users.sh namn1 namn2"
exit 1
fi

# Här börjar loopen för alla namn
for namn in $@
do
  echo "Nu fixar vi användaren: $namn"

  # Skapa användaren och mappen /home/namn
  useradd -m $namn

  # skapa de tre mapparna
  mkdir /home/$namn/Documents
  mkdir /home/$namn/Downloads
  mkdir /home/$namn/Work

  #sätt rättigheter på det enklaste sättet:
  # u=rwx (user får läsa/skriva/köra)
  #ggo= (Group och 0thers får ingeting)
  chmod u=, go= /home$namn/Documents
  chmod u=, go= /home$namn/Downloads
  chmod u=, go= /home$namn/Work

  # Skapa välkkomstfilen
  echo "välkommen $namn" > /home/$namn/welcome.txt
  echo "Här är alla andra användare:" >> /home/$namn/welcome.txt

  # Hämta listan på alla användare (enklaste sättet)
  cut -d: -f1 /etc/passwd >> /home/$namn/welcome.txt

  # Ge användaren ägarskap överallt
  chown -R $namn:$namn /home/$namn

  echo "$namn är klar!"
done

echo "klar med alla!"
