#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

#function to show the element details
function ELEMENT_DETAILS(){
  
  echo "$1" | while IFS='|' read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTINF_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTINF_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
}


# Verification function where the argument is not a number
function SYMBOL_NAME_VERIFICATION(){
          # get element information according for the symbol
          
          ELEMENT_INFORMATIONS=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1'") 

          #if the argument is not the symboll
          if [[ -z $ELEMENT_INFORMATIONS ]]
          then

            # get element according to the name
            ELEMENT_INFORMATIONS=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1'") 

            #if the argument is not the symboll
            if [[ -z $ELEMENT_INFORMATIONS ]]
            then
              echo "I could not find that element in the database."
            else
              ELEMENT_DETAILS $ELEMENT_INFORMATIONS
            fi

          else
            # show element details
            ELEMENT_DETAILS $ELEMENT_INFORMATIONS
          fi

}

# When there is no argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."

else

    #Verify if it a number
    if  [[ "$1" =~ ^[0-9]+$ ]]
    then
        # get element information according to the atomic number
        ELEMENT_INFORMATIONS=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1") 

        # if the argument is  the atomic number
        if ! [[ -z $ELEMENT_INFORMATIONS ]]
        then
          ELEMENT_DETAILS $ELEMENT_INFORMATIONS

        else
          #do other verifications 
          SYMBOL_NAME_VERIFICATION $1
        fi
    else
      SYMBOL_NAME_VERIFICATION $1
    fi
     
    

fi
