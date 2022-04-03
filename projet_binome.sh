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

length_element_pile=${#maPile[@]}

 echo -e "\033[100m  $length_element_pile                           \033[m" #Bordure Haut

for i in {4..1}
do
  
  formatChaine " ${maPile[$i-1]:-"--"} | " 25 " $((i++)):" #affichage des elements de la calculatrice
  
done

echo -e "\033[100m                              \033[m" #Bordure Bas

}

function empile(){
  maPile=("${1}" "${maPile[@]}") #ajout de l'élément en tête de liste
}


function depile(){
  read last <<< "${maPile[0]}" #récupération de la tête de liste
  unset maPile[0] #suppression de la valeur de maPile[0]
  maPile=( "${maPile[@]}") #décalage des éléments de la liste pour que maPile[0]=2 et non vide (puisqu'on a unset maPile[0])
}

function nvchiffre(){

echo -n ">"
read input

if [[ "$input" =~ ^[0-9]+(\.[0-9]+)?$ ]] #si c'est un nombre
then 
  empile $input
else  
  case $input in 
  "P")
    echo "depile: element recupéré: $last" #affiche que si on veut enlver un element
    depile
  ;;
  "STOP"|"stop")
    echo "Arret de la calculatrice !!!"
    exit
  ;;
  "+"|"-"|"*"|"/"|"cos"|"sin"|"tan"|"sqrt") # si c'est un operateur
    operation
  ;;
  *)
  echo "Ce n'est ni un nombre ni un operateur"
  
  ;;
  esac
fi

affichePile #affiche la pile après insertion valeur

}


function operation(){
  depile
  nb1=$last
  depile 
  nb2=$last

  case $input in 
  "+")
    resultat=$(($nb1+$nb2))
  ;;
  "-")
     resultat=$(($nb1-$nb2))
   ;;
  "*") 
    resultat=$(($nb1*$nb2))
  ;;
  "/") 
    resultat=$(($nb1/$nb2))
  ;;
   "cos")
    empile $nb2
    resultat=$(php -r "echo cos($nb1);")
  ;;
  "sin")
    empile $nb2
    resultat=$(php -r "echo sin($nb1);")
  ;;
  "tan")
    empile $nb2
    resultat=$(php -r "echo tan($nb1);")
  ;;
  "sqrt")
    empile $nb2
    resultat=$(php -r "echo sqrt($nb1);")
  ;;

  esac

  empile $resultat
}


#REGION UTILISATION DES FONCTIONS 

maPile=()
empile 0
empile 1
empile 2

affichePile
until [[ "$input" = "STOP" ]]
do 
  nvchiffre
done





#shift
#Q5 optionnel
#mettre -- pour les nombres negatifs
