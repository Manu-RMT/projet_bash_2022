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

function affichePile()
{

  formatChaine "\033[43m|\033[m" 30 

}


affichePile
