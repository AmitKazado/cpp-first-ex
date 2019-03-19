#!/bin/bash

folderName=$1
executeable=$2
arg=${@:3}
currentLocation=`pwd`
valgrindOutput="fail"
helgrindOutput="fail"
trash="/dev/null"
exitCode=0

echo Compilation	Memory leaks	Thread race

cd "$folderName"
echo $arg | make > $trash 2>&1

succesfullMake=$?
if [ $succesfullMake -gt 0 ]; then
echo fail		fail		fail
exit 7
fi

echo $arg | valgrind --leak-check=full --error-exitcode=1 ./$executeable  $arg > $trash 2>&1 
valgrindOut=$?

if [ $valgrindOut -eq 0 ]; then
valgrindOutput="pass"

elif [ valgrindOut -ne 0 ]; then
	((exitCode+=2))
fi


echo $arg | valgrind --tool=helgrind --error-exitcode=1 ./$executeable $arg > $trash 2>&1
helgrindOut=$?

if [ $helgrindOut -eq 0 ]; then
helgrindOutput="pass"
elif [ $helgrindOut -ne 0 ]; then
	((exitCode+=1))
fi

echo "pass		$valgrindOutput		$helgrindOutput"

exit $exitCode
