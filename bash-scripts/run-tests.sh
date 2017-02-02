#!/usr/bin/env bash
#
# This script run a certain number of pairs of process and keep this number of pairs
# running for a certain time. Everytime a pair of process in the set ends, the script
# starts another, until the deadline.
#
# usage: ./run-tests.sh <path-to-script-1> <path-to-script-2> <number-of-pairs> <execution-time> [verification-interval]
# 
# note:
#   - script-2 should be the limiting one, what means, the slow one;
#   - modify processXArgs in the source to correpond <number-of-pairs> and program/script args.
#   
#

# Check if args are provided correctly
if [ "$#" -ne 4 ]; then
    echo "Usage:"
    printf "\t%s <path-to-script-1> <path-to-script-2> <number-of-pairs> <execution-time> [verification-interval]\n" $0
    printf "\n\nnote:\n"
    printf "\t-script-2 should be the limiting one, what means, the slow one.\n"
    printf "\t-modify processXArgs in the source to correpond to programs/scripts args.\n"
    exit 1
fi

# Check if programs/scripts path exists
if [ ! -e $1 ] || [ ! -e $2 ]; then
    echo "One or both scripts paths does't exist. Please verify args."
    exit 1
fi

executionTime=$4
end=$((SECONDS+executionTime))

process1=$1
process2=$2 # process with longer execution time

# This should be substituted for specific applications
process1Args=("arg1" "arg2" "arg3" "arg4")
process2Args=("arg1" "arg2" "arg3" "arg4")

nOfProcessPairs=$3

# Check if args array are provided correctly
if [ $nOfProcessPairs -ne ${#process1Args[@]} ] || [ $nOfProcessPairs -ne ${#process1Args[@]} ]; then
    echo "Process args number don't mach <number-of-pairs>. Check source code and args."
    exit 1
fi

# Start the nOfProcessPairs of each kind with its arguments
for ((i=0; i < $nOfProcessPairs; i++))
do
    $process2 ${process2Args[$i]} &
    $process1 ${process1Args[$i]} &
done

# Sleep time to verify number of process still running
sleeptime='5s'

# Variables to use arguments as circular list
i=0
j=0

# Loop to keep exactly nOfProccess of each kind always running
while :
do
    sleep $sleeptime

    nOfProcess2="$(ps x | grep -v grep | grep -c $process2)"
    
    # Check if a process2 has finished to start another
    while [ $nOfProcess2 -lt $nOfProcessPairs ]; do
        $process2 ${process2Args[$i]} &
        $process1 ${process1Args[$i]} &

        if [ $i -lt $((nOfProcessPairs-1)) ]; then
            ((i++))
        else
            i=0
        fi
        nOfProcess2="$(ps x | grep -v grep | grep -c $process2)"
    done

    # Stop test after the defined execution time has expired
    if [ $SECONDS -ge $end ]; then
        break
    fi

done

echo "OUT OF LOOP! $!"

# Wait for process to finish
wait

echo "Teste finished."
