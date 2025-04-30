#!/usr/bin/bash

steptest=$(step ssh list --raw 'fbonnet08@gmail.com'| step ssh inspect | grep "Valid")
 
if [ -z "$steptest" ]
then
    eval $(ssh-agent)

    echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > ~/.bash_agent

    echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >> ~/.bash_agent

    step ssh login 'fbonnet08@gmail.com' --provisioner cineca-hpc
 
fi

