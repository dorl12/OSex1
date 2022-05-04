#!/bin/bash
#Dor Levy 313547085

points_player_1="50"
points_player_2="50"

player_1_pick=""
player_2_pick=""

ball=0
game_on=true

print_board() {
  echo " Player 1: ${points_player_1}         Player 2: ${points_player_2} "
  echo " --------------------------------- "
  echo " |       |       #       |       | "
  echo " |       |       #       |       | "
  case $ball in

    -3)
      echo "O|       |       #       |       | "
      ;;

    -2)
      echo " |   O   |       #       |       | "
      ;;

    -1)
      echo " |       |   O   #       |       | "
      ;;

    0)
      echo " |       |       O       |       | "
      ;;

    1)
      echo " |       |       #   O   |       | "
      ;;

    2)
      echo " |       |       #       |   O   | "
      ;;

    3)
      echo " |       |       #       |       |O"
      ;;

  esac
  echo " |       |       #       |       | "
  echo " |       |       #       |       | "
  echo " --------------------------------- "
  if [[ $player_1_pick != "" ]] && [[ $player_2_pick != "" ]]
  then
    echo -e "       Player 1 played: ${player_1_pick}\n       Player 2 played: ${player_2_pick}\n\n"
  fi
}

player_pick() {
  regex='^[0-9]+$'
  echo "PLAYER 1 PICK A NUMBER: "
  read -s player_1_pick
  if [[ ! $player_1_pick =~ $regex ]] || [[ $player_1_pick -gt $points_player_1  ]] || [[ $player_1_pick -lt 0 ]]
  then
    while [[ ! $player_1_pick =~ $regex ]] || [[ $player_1_pick -gt $points_player_1  ]] || [[ $player_1_pick -lt 0  ]]
    do
      echo "NOT A VALID MOVE !"
      echo "PLAYER 1 PICK A NUMBER: "
      read -s player_1_pick
    done
  fi
  points_player_1=`expr $points_player_1 - $player_1_pick`
  echo "PLAYER 2 PICK A NUMBER: "
  read -s player_2_pick
  if [[ ! $player_2_pick =~ $regex ]] || [[ $player_2_pick -gt $points_player_2  ]] || [[ $player_2_pick -lt 0 ]]
  then
    while [[ ! $player_2_pick =~ $regex ]] || [[ $player_2_pick -gt $points_player_2  ]] || [[ $player_2_pick -lt 0  ]]
    do
      echo "NOT A VALID MOVE !"
      echo "PLAYER 2 PICK A NUMBER: "
      read -s player_2_pick
    done
  fi
  points_player_2=`expr $points_player_2 - $player_2_pick`
}

move_ball() {
  if [[ $player_1_pick -lt $player_2_pick ]]
  then
    if [ $ball -lt 0 ]
    then
      ball=`expr $ball - 1`
    else
      ball=-1
    fi
  elif [[ $player_2_pick -lt $player_1_pick ]]
  then
    if [ $ball -gt 0 ]
    then
      ball=`expr $ball + 1`
    else
      ball=1
    fi
  fi
}

check_winner() {
  if [ $ball == 3 ] || [ $ball == -3 ]
  then
    if [ $ball == 3 ]
    then
      echo "PLAYER 1 WINS !"
      game_on=false
    fi
    if [ $ball == -3 ]
    then
      echo "PLAYER 2 WINS !"
      game_on=false
    fi
  elif [ "$points_player_1" == 0 ] && [ "$points_player_2" != 0 ]
  then
    echo "PLAYER 2 WINS !"
    game_on=false
  elif [ "$points_player_1" == 0 ] && [ "$points_player_2" != 0 ]
  then
    echo "PLAYER 2 WINS !"
    game_on=false
  elif [ "$points_player_2" == 0 ] && [ "$points_player_1" != 0 ]
  then
    echo "PLAYER 1 WINS !"
    game_on=false
  elif [ "$points_player_1" == 0 ] && [ "$points_player_2" == 0 ]
  then
    if [ $ball -lt 0 ]
    then
      echo "PLAYER 2 WINS !"
      game_on=false
    elif [ $ball -gt 0 ]
    then
      echo "PLAYER 1 WINS !"
      game_on=false
    else
      echo "IT'S A DRAW !"
      game_on=false
    fi
  fi
}

print_board
while $game_on
do
  player_pick
  move_ball
  print_board
  check_winner
done