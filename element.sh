#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


if [[ $1 ]]
then
  #variable to hold info about the element
  ELEMENT=""
  #if the argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "select elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, melting_point_celsius, boiling_point_celsius from elements  INNER JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types ON types.type_id=properties.type_id WHERE elements.atomic_number=$1;")

  #if elements symbol is given
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    ELEMENT=$($PSQL "select elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, melting_point_celsius, boiling_point_celsius from elements  INNER JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types ON types.type_id=properties.type_id WHERE elements.symbol='$1';")

  elif [[ $1 =~ ^[A-Z][a-z]+$ ]]
  then
    ELEMENT=$($PSQL "select elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, melting_point_celsius, boiling_point_celsius from elements  INNER JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types ON types.type_id=properties.type_id WHERE elements.name='$1';")
  fi

  #if the element string remains empty
  if [[ ! -z $ELEMENT ]]
  then
    echo $ELEMENT | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  else
    echo "I could not find that element in the database."
  fi

  else
    echo -e "Please provide an element as an argument."
fi