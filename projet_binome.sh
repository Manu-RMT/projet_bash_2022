#!/bin/bash

function formatChaine()
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
  
  echo -ne "\033[100m \033[m" #Boedure gauche
  echo -ne "$3$resu"
  echo -e "\033[100m \033[m" #Bordure Droite
}

function affichePile()
{

 echo -e "\033[100m                              \033[m" #Bordure Haut

for i in {4..1}
do
  
  formatChaine " ${maPile[$i-1]:="--"} | " 25 " $((i++)):" #affichage des elements de la calculatrice
  
done

echo -e "\033[100m                              \033[m" #Bordure Bas

}

function empile(){
  maPile=("${1}" "${maPile[@]}") #ajout de l'élément en tête de liste
}


function depile(){
  read last <<< "${maPile[0]}" #récupération de la tête de liste
  echo "depile: element recupéré: $last"
  unset maPile[0] #suppression de la valeur de maPile[0]
  maPile=( "${maPile[@]}") #décalage des éléments de la liste pour que maPile[0]=2 et non vide (puisqu'on a unset maPile[0])
  affichePile
}

function nvchiffre(){
  echo -n ">"
  read input
  if [ $input = "P" ]
    then
      depile
    else  
      empile $input
  fi
}


#REGION UTILISATION DES FONCTIONS 

maPile=()
empile 0
empile 1
empile 2
nvchiffre

#6.1 q1 affichePile

depile
depile




#shift
#Q5 optionnel
#mettre -- pour les nombres negatifs

