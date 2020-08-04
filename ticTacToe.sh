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

#function to check right options-
function checkOptions(){
	option=$1

	while [ $option -ne $OPTION_VALUE1 ] && [ $option -ne $OPTION_VALUE0 ]
	do
   	read -p "Wrong input.Please enter 0 or 1 : " option
	done
	echo $option
}

#function for choosing user's letter
function chooseUserLetter(){
	read -p "Enter 1 for x and 0 for o : " userOption
	userOption=$(checkOptions $userOption)
	if [ $userOption -eq $OPTION_VALUE1 ]
	then
			computerOption=$OPTION_VALUE0
	else
			computerOption=$OPTION_VALUE1
	fi
	printf '%d\3' "$userOption" "$computerOption"
}

#function for choosing computer's letter
function chooseComputerLetter(){
	computerOption=$((RANDOM % 2))
	if [ $computerOption -eq $OPTION_VALUE1 ]
	then
		userOption=$OPTION_VALUE0
	else
		userOption=$OPTION_VALUE1
	fi
	printf '%d\3' "$userOption" "$computerOption"
}

echo "Welcome to the game of Tic Tac Toe!!"
resetBoard

read -p "Enter your toss choice between 0 and 1 : " tossValue
tossValue=$(checkOptions $tossValue)

toss=$((RANDOM % 2))
echo "Toss result : $toss"

if [[ $tossValue -eq $toss ]]
then
	echo -e "User wins the toss.\nUser will go first."
	IFS="$(printf '\3')"
	set -- $(chooseUserLetter)
	userChoice=$1
	computerChoice=$2
else
	echo -e "Computer wins the toss.\nComputer will go first"
	IFS="$(printf '\3')"
   set -- $(chooseComputerLetter)
   userChoice=$1
   computerChoice=$2
fi

#assigning letters to user and computer
if [ $userChoice -eq $OPTION_VALUE1 ]
then
	user="x"
	computer="o"
else
	user="o"
	computer="x"
fi

echo -e "User will play as $user. \nComputer will play as $computer "
