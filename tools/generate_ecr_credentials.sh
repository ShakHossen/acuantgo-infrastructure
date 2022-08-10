#!/bin/bash

##
## Generate a base64 AWS ECR registry access credentials.
##
## - Uses the 'aws ecr get-login-password' command to obtain the registry authentication token.
## - The generated credentials can be checked using the 'base64 --decode' command.
##

script=`basename $0`

##
## Print the script command line usage and exit.
##
function print_usage {

    printf "\nGenerate base64 AWS ECR registry access credentials.\n"

    printf "\nUsage: %s %s %s\n" $script "AWS_ACCOUNT" "AWS_REGION"
    printf "\nWhere:\n\n"
    printf "AWS_ACCOUNT\t= An AWS account number; 858475722663 for example.\n"
    printf "AWS_REGION\t= An AWS region; us-east-1 for example.\n\n"

    exit 1

}

##
## Process the script's command line arguments.
##
function process_args {

    if [[ $# -ne 2 ]] ; then
        print_usage
    fi

    invalid_args=false

    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
        printf "[ERROR]: Argument 1 '%s' is not a number.\n" $1
        invalid_args=true
    fi

    if ! [[ "$2" =~ ^[a-z]+\-[a-z]+\-[0-9]+$ ]]; then
        printf "[ERROR]: Argument 2 '%s' is not an valid region format.\n" $2
        invalid_args=true
    fi

    if [[ "$invalid_args" = true ]]; then
        print_usage
    fi

}

process_args "$@"

AWS_ACCOUNT=$1
AWS_REGION=$2

LOGIN_PASSWORD=$(aws ecr get-login-password)
if [[ $? -ne 0 ]]; then
    printf "[ERROR]: $script: Failed to get AWS login password.\n"
    exit 2
fi

AUTHS=`printf "{\"auths\":{\"%s.dkr.ecr.%s.amazonaws.com\":{\"username\":\"AWS\",\"password\":\"%s\"}}}" ${AWS_ACCOUNT} ${AWS_REGION} ${LOGIN_PASSWORD}`

echo $AUTHS | base64