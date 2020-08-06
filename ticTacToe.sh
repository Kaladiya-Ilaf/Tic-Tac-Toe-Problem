#!/bin/bash -x

#defining total length of grid
GRID_LENGTH=9

#Constants to compare and select toss and letter
OPTION_VALUE1=1
OPTION_VALUE0=0

#constants for letters
letterX="x"
letterO="o"

#array as playing board
declare -a board

#Function to print the board
function printBoard(){
	playBoard=("$@")
	echo "   ${playBoard[0]} | ${playBoard[1]} | ${playBoard[2]}"
	echo "   ========="
	echo "   ${playBoard[3]} | ${playBoard[4]} | ${playBoard[5]}"
	echo "   ========="
	echo -e "   ${playBoard[6]} | ${playBoard[7]} | ${playBoard[8]} \n"
}

#function that resets the board
function resetBoard(){
	echo "New Game :"

	for (( i=0; i<$GRID_LENGTH; i++))
	do
		board[i]="$i"
	done

	printBoard ${board[@]}
}

#function to check available valid cells
function checkValidCell(){
	board=("$@")
	availableCells=()

	for  i in ${board[@]}
	do
		if [ "$i" == "$letterX" ] || [ "$i" == "$letterO" ]
		then
			continue
		fi
		availableCells+=($i)
	done

	echo >&2 ${availableCells[@]}
	echo  ${#availableCells[@]}
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

#function to decide who is the winner
function decideWinner(){

	if [ $presentPlayer -eq 1 ]
	then
		echo >&2 "Computer won."
	else
		echo >&2 "User won."
	fi

	echo $OPTION_VALUE1
}

#function to check all condition of winning
function checkWin(){
	if [[ ${board[0]} == ${board[1]} && ${board[1]} == ${board[2]} ]]
	then
		echo $OPTION_VALUE1
	elif [[ ${board[3]} == ${board[4]} && ${board[4]} == ${board[5]} ]]
	then
		echo $OPTION_VALUE1
	elif [[ ${board[6]} == ${board[7]} && ${board[7]} == ${board[8]} ]]
	then
		echo $OPTION_VALUE1
	elif [[ ${board[0]} == ${board[3]} && ${board[3]} == ${board[6]} ]]
	then
		echo $OPTION_VALUE1
	elif [[ ${board[1]} == ${board[4]} && ${board[4]} == ${board[7]} ]]
	then
		echo $OPTION_VALUE1
	elif [[ ${board[2]} == ${board[5]} && ${board[5]} == ${board[8]} ]]
	then
		echo $OPTION_VALUE1
	elif [[ ${board[0]} == ${board[4]} && ${board[4]} == ${board[8]} ]]
	then
		echo $OPTION_VALUE1
	elif [[ ${board[2]} == ${board[4]} && ${board[4]} == ${board[6]} ]]
	then
		echo $OPTION_VALUE1
	else
		echo $OPTION_VALUE0 
	fi
}

#function to check win, tie or contiue playing option
function checkCondition(){
	win=$(checkWin)
	if [[ $win -eq $OPTION_VALUE0 ]] && [[ $cellsAvailable -lt $OPTION_VALUE0 ]]
	then
		terminateGame=$OPTION_VALUE0
	elif [[ $win -eq $OPTION_VALUE0 ]] && [[ $cellsAvailable -ge $OPTION_VALUE0 ]]
	then
		echo >&2 -e "Continue...\n"
		terminateGame=$OPTION_VALUE0
	else
		echo >&2 -e "WIN\n"
		terminateGame=$(decideWinner)
	fi
}

#function to check winning possiblity
function checkWinningPossibility(){
	i=0

	while [ $i -lt $GRID_LENGTH ]
   do
		if [[ "${board[$i]}" == "$letterX" ]] || [[ "${board[$i]}" == "$letterO" ]]
      then
			board[$i]=$i
			presentPlayer=$OPTION_VALUE0
			break
		else
      	board[$i]=$symbol
         WinGame=$(checkWin)
		fi
		if [[ $WinGame == 1 ]]
		then
			presentPlayer=$OPTION_VLAUE1
			WinGame=0
			board[$i]=$i
			echo >&2 "Selected : $i"
			break
		fi

      i=$(( i + 1 ))
	done
	echo $i
}


#function to determine action during computers turn
function computerTurn(){
	WinGame=0
	symbol=$1

		position=$(checkWinningPossibility)
	if [ $presentPlayer -eq $OPTION_VALUE0 ]
	then
		position=$(( $(( $RANDOM % $GRID_LENGTH )) ))

		while [ "${board[$position]}" == "$letterX" ] || [ "${board[$position]}" == "$letterO" ]
		do
			position=$(( $(( $RANDOM % $GRID_LENGTH )) ))
		done
	fi

	board[$position]=$symbol
	echo "Computer selects:" $position
}

#function thata takes action during user's turn
function userTurn(){
	symbol=$1
	read -p "Enter position between 0-8 :" position

	if [[ $position -lt $GRID_LENGTH ]] && [[ $position -ge $OPTION_VALUE0 ]]
	then
		while [ "${board[$position]}" == "$letterX" ] || [ "${board[$position]}" == "$letterO" ]
		do
			read -p "$position occupied.Enter another position between 0 to 8 : " position
		done
	else
		read -p "Enter position between 0-8 :" position
	fi

	board[$position]=$symbol
	echo "User selects:" $position
}

#function to play game
function play(){
	presentPlayer=$1
	userSymbol=$2
	computerSymbol=$3
	terminateGame=$OPTION_VALUE0

	while [[ $terminateGame -ne $OPTION_VALUE1 ]] 
	do
		echo "Available Valid Choices :"
		cellsAvailable=$(checkValidCell ${board[@]})
		echo -e "Total cells available : ${cellsAvailable}\n"
		printBoard ${board[@]}

		if [ $presentPlayer -eq $OPTION_VALUE0 ]
		then
			computerTurn $computerSymbol
			presentPlayer=$OPTION_VALUE1
		else
			userTurn $userSymbol
			presentPlayer=$OPTION_VALUE0
		fi
			checkCondition ${board[@]}

		cellsAvailable=$(checkValidCell ${board[@]})
		if [[ $cellsAvailable -eq $OPTION_VALUE0 ]]
		then
			terminateGame=$OPTION_VALUE1
			echo tie
		fi
	done
	printBoard ${board[@]}
}

echo "Welcome to the game of Tic Tac Toe!!"
resetBoard

read -p "Enter your toss choice between 0 and 1 : " tossValue
tossValue=$(checkOptions $tossValue)

toss=$((RANDOM % 2))
echo "Toss result : $toss"

if [[ $tossValue -eq $toss ]]
then
	echo -e "User wins the toss.\nUser will go first. \n"
	IFS="$(printf '\3')"
	set -- $(chooseUserLetter)
	userChoice=$1
	computerChoice=$2
	playerTurn=$OPTION_VALUE1
else
	echo -e "Computer wins the toss.\nComputer will go first \n"
	IFS="$(printf '\3')"
	set -- $(chooseComputerLetter)
	userChoice=$1
	computerChoice=$2
	playerTurn=$OPTION_VALUE0
fi

#assigning letters to user and computer
if [ $userChoice -eq $OPTION_VALUE1 ]
then
	user=$letterX
	computer=$letterO
else
	user=$letterO
	computer=$letterX
fi

echo -e "User will play as $user. \nComputer will play as $computer. \n"

echo -e "Game Started: \n"

play $playerTurn $user $computer

