#!/bin/bash

#defining total length of grid
GRID_LENGTH=9

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
