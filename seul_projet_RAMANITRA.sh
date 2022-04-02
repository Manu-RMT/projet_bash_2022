#!/bin/bash

nom1="RAMANITRA"
prenom1="Manuel"
nom2="MONTALAND Quentin"
date_jour=$(date)

echo "______________________________ "
echo "----- Projet Suivi      ------ "
echo "___ MIASHS 2022          _____ "
echo "___ Calculatrice         _____ "
echo "__ Par : ${nom1:0:11} ${prenom1:0:1}       ___"
echo "__ et : ${nom2:0:11}        ___"
echo "- ${date_jour:0:25} --"
echo "______________________________ "

maPile=()

echo -n "Saisir la premiere valeur de la pile :"  
read val1
maPile+=($val1)
echo "Contenu de la pile : ${maPile[@]} "

echo -n "Saisir la deuxième valeur de la pile :"  
read val2
maPile+=($val2)
echo "Contenu de la pile : ${maPile[@]} "

echo -n "Saisir la troisieme valeur de la pile :"  
read val3
maPile+=($val3)
echo "Contenu de la pile : ${maPile[@]}"

echo -n "Saisir la quatrième valeur de la pile :"  
read val4
maPile+=($val4)
echo "Contenu de la pile : ${maPile[@]}"


formatChaine()
{
  mot=$1
  longueur=$2
  symboleDebut=$3
  resu=$mot
  longueurMot=${#mot}
  dif=$((longueur-longueurMot))
  for ((i=0;i<dif;i++)){
    resu=" $resu"
  }

  # echo -ne "\033[47m|\033[0m";
  echo "$3$resu"
 # echo -e "\033[47m|\033[0m";
}


affichePile()
{
echo "Test de l'affichage amelioré de la pile"
echo -e "\033[43m                                   \033[m" #couleur haut
for i in {4..1}
do
  echo -ne "\033[47m|\033[0m"; #couleur coté gauche
 
  echo -e "\033[36m" `formatChaine " " 20 "$((i++)):" " "` "                        ${maPile[i-1]:="--"} |\033[0m \033[47m|\033[0m" 
  #formatChaine "${maPile[$i-1]:="--"} |" 30 "$((i++)):"
  
done

echo -e "\033[43m                                   \033[0m" #couleur bas
}

affichePile

testNombre(){
  echo -n "Entrez un nombre : "
  read nbInserer

  if [[ "$nbInserer" =~ ^[0-9]+(\.[0-9]+)?$ ]]
  then
   echo "Nombre OK"
  else
   echo "Ce n'est ni un nombre entier ou ni un nombre decimal"
  fi
}  


testNombre

echo "test de la question 4"
echo "Formatage de  " `formatChaine "'Bonjour Miash !'" 20 ""` "sur une taille de 20"
echo "Formatage de  " `formatChaine "'Salut il fait beau !'" 20 ""`
echo `formatChaine "Bonjour MIASH!" 20 "1:"`
echo `formatChaine "Salut il faut beau" 20 "2:"`