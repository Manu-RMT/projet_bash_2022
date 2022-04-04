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

length_element_pile=${#maPile[@]} #initialisation pour nb element dans la piile

# si on a sauvegardé une valeur et donc non vide
if [[ ${#SauvegardeValeur[*]} != 0 ]]
then
  for index in "${!SauvegardeValeur[@]}" #parcours tableau par index car on peut avoir plusierus sauvegardes  
  do
    echo "save="$index #affiche l'index
  done
fi

#gestion affichage calculatrice
 echo -e "\033[100m  $length_element_pile                           \033[m" #Bordure Haut et nb elements pile

for i in {4..1} #donne les 4 derniers elements par ordre decroissant
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
  maPile=("${maPile[@]}") #décalage des éléments de la liste pour que maPile[0]=2 et non vide (puisqu'on a unset maPile[0]) (comme un shift)
}

function TraitementCalculatrice(){

#input box
echo -n ">"
read input

if [[ "$input" =~ ^[+-]?[0-9]+(\.[0-9]+)?$ ]] #si c'est un nombre on empile
then
  empile $input

# traitement sauvegarde valeur à reutiliser utlérieurement
elif [[ ${input:0:4} == "save" && ${#maPile[*]} != 0 ]] # si ca commence par save pour sauvegarder et qu'il y ait une valeur à sauvegarder
then
    
  new_val=${input:4} #variable prend comme valeur la suite du save
  depile #on supprime le dernier nombre de la calculatrice
  SauvegardeValeur[$new_val]=$last #index = suite de save et valeur = element dépilé

#traitement recuperation valeur(s) sauvegardé
elif [[ ${input:0:4} == "echo" && ${#SauvegardeValeur[*]} != 0 ]]  #si ca commence par echo et tableau valeur sauvegarder non vide 
then
  for index in "${!SauvegardeValeur[@]}" #parcours du tableau par index
  do
    if [[ ${input:4} == $index ]] #verifie si la suite de echo correspond à un index du tableau
    then
      empile ${SauvegardeValeur[$index]} #on le remet dans la calculatrice
      unset SauvegardeValeur[$index] # on supprime element du tableau  
    else
      echo "variable non sauvegarder : " ${input:4} # sinon
    fi
  done
else  
  case $input in
  "P"|"p") #si on s'est trompé
    depile
    echo "depile: element recupéré: $last" #affiche element dépilé
  ;;
  "STOP"|"stop") #arret le programme
    clear #nettoie le terminal
    echo "Arret de la calculatrice !!!"
    exit
  ;;
  "+"|"-"|"*"|"/"|"cos"|"sin"|"tan"|"sqrt") # si c'est un operateur lance la fonction operation
    operation
  ;;
  *) #sinon on ne fait rien
    echo "Ce n'est ni un nombre ni un operateur" 
    echo "OU il n'y a pas encore de valeur à sauvegarder "
    echo "OU à remettre dans la calculatrice"
  ;;
  esac
fi


affichePile #affiche la pile après insertion valeur

}


function operation(){
#depile et stoke les deux derniers valeurs de la calculatrice dans des nouvelles vatiables
# pour les utilisers par la suite


depile
nb1=${last:-0} #si vide remplace par 0
depile
nb2=${last:-0}

case $input in
  "+") #addition
    resultat=$(($nb1+$nb2))
  ;;
  "-") #soustraction
     resultat=$(($nb1-$nb2))
   ;;
  "*") #multiplication
    resultat=$(($nb1*$nb2))
  ;;
  "/") #division
    if [[ $nb2 != 0 ]] # si le denominateur ne vaut pas 0
    then
      resultat=$(($nb1/$nb2))
    else #sinon resultat = derniere element de la pile
      echo "operation impossible : division par 0"
      resultat=$nb1
    fi
  ;;
  # ATTENTION PARTICULIERE CAR IL FAUT REEMPILER LA DERNIERE VALEUR
  "cos") #cosinus
    empile $nb2
    resultat=$(php -r "echo cos($nb1);")
  ;;
  "sin") #sinus
    empile $nb2
    resultat=$(php -r "echo sin($nb1);")
  ;;
  "tan") #tangeante
    empile $nb2
    resultat=$(php -r "echo tan($nb1);")
  ;;
  "sqrt") #racine carrée
    empile $nb2
    resultat=$(php -r "echo sqrt($nb1);")
  ;;
esac
 
# on remet la nouvelle valeur dans la calculatrice
empile $resultat

}


#REGION UTILISATION DES FONCTIONS
maPile=() #init tableau valeur  
declare -A SauvegardeValeur #init tableau des valeurs à sauvegarder

affichePile #affichage de la pile
until [[ "$input" = "STOP" ]] #boucle qui permet de ne jamais stopper la calculatrice tans que l'utilisateur n'a pas mis stop
do
  TraitementCalculatrice #traitement de la calculatrice
done







