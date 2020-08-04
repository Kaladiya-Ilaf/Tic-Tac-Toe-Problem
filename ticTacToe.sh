#!/bin/bash

#defining total length of grid
GRID_LENGTH=9

#Constants to compare and select toss and letter
OPTION_VALUE1=1
OPTION_VALUE0=0

#Function to print the board
function printBoard(){
   board=("$@")
   echo "   ${board[0]} | ${board[1]} | ${board[2]}"
   echo "   ========="
   echo "   ${board[3]} | ${board[4]} | ${board[5]}"
   echo "   ========="
   echo "   ${board[6]} | ${board[7]} | ${board[8]}"
}

#function that resets the board
function resetBoard(){
	declare -a board

	echo "New Board :"
	for (( i=1; i<=$GRID_LENGTH; i++))
	do
		board[i]="$i"
	done

	printBoard ${board[@]}
}

echo "Welcome to the game of Tic Tac Toe!!"
resetBoard

read -p "Enter your toss choice between 0 and 1 : " tossValue

#Asking right value required for toss until obtained
while [ $tossValue -ne $OPTION_VALUE1 ] && [ $tossValue -ne $OPTION_VALUE0 ]
do
	read -p "Wrong input.Please enter 0 or 1 : " tossValue
done

toss=$((RANDOM % 2))
echo "Toss result : $toss"

if [ $tossValue -eq $toss ]
then
	echo -e "User wins the toss.\nUser will go first."
else
	echo -e "Computer wins the toss.\nComputer will go first"
fi
