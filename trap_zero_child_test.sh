# No hash-bang in this script. We intend it to be run as an argument to the shell to
# permit testing against multiple shells.
# 
# trap_zero_test.sh
# Script to test which signals will cause trap zero to be executed for the shell
#
# For each signal under test:
# - launch a child process which has the task writing a string to a file upon execution
#   of trap zero. The child process shall idle (sleep) until killed or will timeout
#	after approximately 3 seconds.
# - Send the signal to the child process.
# - Observe whether trap zero is triggered by examining the content of the written file.

		set -x

		TEMP_FILE=/tmp/foodlw
		# Configured the trap
		trap "echo in trap; echo Trap0 > $TEMP_FILE" 0
		
		# Let the parent process know we have configured the trap.
		echo Ready > $TEMP_FILE

		# Timeout the process in 3 seconds if not alredy killed.
		sleep 20 &
		wait
		
		# Reset the trap if it hasn't already been fired.
		trap "" 0
