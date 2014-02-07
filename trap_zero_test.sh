# No hash-bang in this script. We intend it to be run as an argument to the shell to
# permit testing against multiple shells.
# 
# trap_zero_test.sh
# Script to test which signals will cause trap zero to be executed for the shell
#
# For each signal under test:
# - launch a child process which has the task writing a string to a file upon execution
#   of trap zero. The child process shall send itself the signal and then sleeps until
#   timeout after approximately 3 seconds unless the signal handler causes an exit.
# - Observe whether trap zero is triggered by examining the content of the written file.

# Create the temporary file for child processes to write to. Clean up the file on exit.
TEMP_FILE=$(mktemp)
trap "rm $TEMP_FILE" 0

# Print a header
printf "Signal\tName\tTrap 0 Executed\n"
for signal in $(seq 1 15); do
	printf "$signal\t$(kill -l $signal)\t"
	
	# Clear the temporary file ready for writing to by the child process.
	: > $TEMP_FILE

	# Launch the child process using a script customised to the signal under test.
	$SHELL -s <<-EOSCRIPT
		# Configured the trap
		trap "echo Trap0 > $TEMP_FILE" 0

		# Send the test signal.
		kill -$signal \$\$
		
		# Timeout the process in 3 seconds if not alredy killed.
		sleep 3 &
		wait
		
		# Reset the trap if it hasn't already been fired.
		trap 0
	EOSCRIPT
	
	# Observe whether trap 0 was fired in the child process.
	result="No"
	[ "$(cat $TEMP_FILE)" = "Trap0" ] && result="Yes"
	echo $result
done

