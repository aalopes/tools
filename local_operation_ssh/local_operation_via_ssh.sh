#!/bin/bash

# =============================================================================
# This script is meant to run a local script on several different hosts via ssh.
#
# Note that this needs gnu ping and probably won't work with cygwin!
# Not also, that without the -n flag, ssh makes the while loop terminate too 
# early.
#
# The list of hosts is in list_of_hosts.txt. One should write one host name
# per line
#
# =============================================================================
#
# Copyright (c) 2015, Alexandre Lopes
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, 
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
#
# =============================================================================

# functions definitions -------------------------------------------------------

check_host ()
{
# Checks whether or not host is alive

COUNTER=3                          	# Maximum number of times to ping
while [ $COUNTER -ne 0 ] ; do
    ping -c 1 $1 > /dev/null        # Ping only once
    REACHABLE=$?                    # Output variable
    if [ $REACHABLE -eq 0 ] ; then
		return 0                    # Successfully pinged
    fi
    ((COUNTER=COUNTER-1))
done
return 1
}

# main ------------------------------------------------------------------------

while read HOST; do

	echo "======================================================="
	echo "==================    HOST    ========================="
	echo "======================================================="

	check_host "HOST" 	 # check if machine is reachable
	if [ $? -eq 0 ]; then 

		# run local operation 
		(ssh HOST "/bin/sh -s" < ./local_operations.sh)
		
	fi
done < list_of_hosts.txt
