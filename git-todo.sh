#!/bin/bash

DONE=$(echo -e "\xE2\x9C\x93")
TODO=$(echo -e "\xE2\x98\x90")
IN_PROGRESS=$(echo -e "\xE2\x96\xA5")

TODO_FILE_NAME="TODO.md"
title="Todo list"
question="Check to mark done"

if [ ! -e "$TODO_FILE_NAME" ]
then 
echo "Todo List Iniialisation ...."
touch $TODO_FILE_NAME
fi

function usage(){
   printf "Usage git-add : \n"
   printf "\t-a    : Add new todo \n"
   printf "\t-l    : Show todo list \n"
   printf "\t-c    : Change status\n"
}


function list(){
if [[  "" == `cat $TODO_FILE_NAME` ]]
then
cat <<EOF
Your todo list is blank.
To add a think todo please type :
  git todo -a
EOF
else
cat $TODO_FILE_NAME | sed "s/^todo: /$TODO /g" | sed "s/^done: /$DONE /g"  | sed "s/^in-progress: /$IN_PROGRESS /g" >&2
fi
}


function add() {
	while true; do
	    echo "What todo ?"
	    read -p "" todo
	    case $todo in
		"") echo 'Thank for using git-todo';
		  exit;;
		* ) echo "todo: $todo" >> $TODO_FILE_NAME;;
	    esac
	done
}

function change_status() {
	while true; do
	    echo "Chose todo to change his status ?"
	    cat --number $TODO_FILE_NAME  | sed -E 's/(done: |in-progress: |todo: )//g'
	    read -p "Please type a number: " number
	    case $number in
		"") echo "Aborted";
  		  exit;;
		*) set_status $number  ;;
	    esac
	done
}

function set_status() {
        todo_line=$1
        echo $todo_line
	while true; do
	    echo ""
	    read -p "Choose a status  
1 done
2 in-progress
Please type a number: " number
	    case $number in
		1) new_status="done"
		   line=$(cat --number $TODO_FILE_NAME  | grep -E $todo_line | sed -E "s/\s+$todo_line\s+(done: |in-progress: |todo: .*)/\1/g")
		   new_line=$(echo $line | sed -E "s/(done: |in-progress: |todo: )/$new_status: /g")
		   echo "sed -i 's/$line/$new_line/g' $TODO_FILE_NAME"
		   sed -i "s/$line/$new_line/g" $TODO_FILE_NAME
                   echo "set $new_status" 
		   exit;;
		2) new_status="in-progress"
		   line=$(cat --number $TODO_FILE_NAME  | grep -E $todo_line | sed -E "s/\s+$todo_line\s+(done: |in-progress: |todo: .*)/\1/g")
		   new_line=$(echo $line | sed -E "s/(done: |in-progress: |todo: )/$new_status: /g")
		   echo "sed -i 's/$line/$new_line/g' $TODO_FILE_NAME"
		   sed -i "s/$line/$new_line/g" $TODO_FILE_NAME
                   echo "set $new_status" 
		   exit;;
		*)echo "Aborted" exit   ;;
	    esac
	done
}

if [ $# -eq 0 ]
then
usage
fi
 


while getopts "l a c" opt; do
  case $opt in
    l)
      list;
      exit;;
    a)
      add;
      exit;;
    c)
      change_status;
      exit;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done


