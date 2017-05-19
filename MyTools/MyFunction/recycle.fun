recycle()
{
	x=$RANDOM
	while [ -e $x ]
	do
		x=$RANDOM
	done
	mv $1 ~/recycle/$x
}
