unset DIRLIST
function lsd()
{
	unset DIRLIST
	local TMPLIST=$(ls -a)
	local  i=0
	for file in $TMPLIST
	do
		echo $file
		if [ -d $file ]
		then 
			DIRLIST[$i]=$file
			let ' i=i+1 '
		fi
	done
	lsd_print
}
function lsd_print()
{
	clear
	echo -e "\033[33m\t\t\t\tsource id\n\033[0m"
	for((i=0; i<${#DIRLIST[@]}; i++))
	do
		lsd_echo_msg ${DIRLIST[$i]} $i
	done
}
function lsd_echo_msg()
{
	dir=$1
	num=$2
	if test -f $dir/.log/get.log
	then
		id=$( cat "$dir/.log/get.log" )
		id=${id##* }
	else
		id=""
	fi
	printf "\t"
	printf %-8s "$num"
	printf "\t"

	echo -e "\033[36m\c"
	printf %-30s "$dir"
	echo -e "\033[0m\c"

	printf "\t"
	printf %-8s "$id"
	printf "\n"
}

