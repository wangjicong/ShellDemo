#!/bin/bash
function go
{
if test -d ./${DIRLIST[$1]}
then 
	cd ${DIRLIST[$1]}
fi
unset DIRLIST
}
