#!/usr/bin/env bash

#------------------------------------------------------------------------------
#          __
#     ____/ /___
#    / __  / __ \
#   / /_/ / /_/ /
#   \__,_/\____/
#
# Author   Vish Vishvanath<vishal.vishvanath@capgemini.com>
# Date:    21 Nov 2017
# Version: 3.0
# Description: Comprehensive shell script providing helper functions, tools and
# syslog integration. For building AWS infrastructure.
# For both local use and server use.

## Running an old version of Bash? Get outta here.
[[ $BASH_VERSINFO -lt 4 ]] && \
  echo "Your version of Bash is ancient. Are you running OS X?" && exit

# give each run of this script a UUID to identify it in the logs
# SID=`od -x /dev/urandom | head -1 | awk '{OFS="-"; print $2$3,$4,$5,$6,$7$8$9}'`
SID="$(date +%s)"


#------------------------------------------------------------------------------
#    __  ___________ _____ ____
#   / / / / ___/ __ `/ __ `/ _ \
#  / /_/ (__  ) /_/ / /_/ /  __/
#  \__,_/____/\__,_/\__, /\___/
#                  /____/
#
usage(){
  echo "Usage: $0 <bootstrap|plan|apply|destroy|teardown>"
  echo
  echo "do - Run interactively"
  echo "do bootstrap - Set up your S3 state bucket"
  echo "do teardown - Destroy the S3 state bucket"
  echo "do plan -e <env_file> -l <layer> - Terraform plan AWS infrastructure"
  echo "do apply -e <env_file> -l <layer> - Terraform apply"
  echo "do destroy -e <env_file> -l <layer> - Terraform destroy"
  echo "do output -e <env_file> -l <layer> - Terraform output"
  1>&2
  exit 1
}

[[ $1 == "-h" ]] && usage

## Send output to syslog, but only after usage prints out
exec >& >(exec logger -s -t "$(basename $0) ${SID}") 2>&1


#------------------------------------------------------------------------------
#                                                        __
#    ____ _____________  ______ ___  ___     _________  / /__
#   / __ `/ ___/ ___/ / / / __ `__ \/ _ \   / ___/ __ \/ / _ \
#  / /_/ (__  |__  ) /_/ / / / / / /  __/  / /  / /_/ / /  __/
#  \__,_/____/____/\__,_/_/ /_/ /_/\___/  /_/   \____/_/\___/
#
# Setup assume role tings
unset AWS_SESSION_TOKEN

temp_role=$(aws sts assume-role \
  --role-arn "arn:aws:iam::${AWS_ACCOUNT_NUMBER}:role/${AWS_ROLE}" \
  --role-session-name "${SID}" \
  --duration-seconds 3600)

# Check everything is OK and print any error string
echo $temp_role


export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq .Credentials.AccessKeyId | xargs)
export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq .Credentials.SecretAccessKey | xargs)
export AWS_SESSION_TOKEN=$(echo $temp_role | jq .Credentials.SessionToken | xargs)

if  [ -z "$AWS_ACCESS_KEY_ID"  -o  -z "$AWS_SECRET_ACCESS_KEY" -o -z  "$AWS_SESSION_TOKEN" ] ; then
  echo "Unable to assume temporary role named '${SID}' using '${AWS_ACCOUNT_NUMBER}:role/${AWS_ROLE}'."
  echo "Have you set up your environment correctly?"
  exit 1
fi


#------------------------------------------------------------------------------
#                                  __                    _____
#    ___  ______________  _____   / /_  ____ _____  ____/ / (_)___  ____ _
#   / _ \/ ___/ ___/ __ \/ ___/  / __ \/ __ `/ __ \/ __  / / / __ \/ __ `/
#  /  __/ /  / /  / /_/ / /     / / / / /_/ / / / / /_/ / / / / / / /_/ /
#  \___/_/  /_/   \____/_/     /_/ /_/\__,_/_/ /_/\__,_/_/_/_/ /_/\__, /
#                                                                /____/
#
declare -A LISTENERS

# run functions (listeners) for events
throw(){
  EVENT=$1; shift; for listener in "${LISTENERS[$EVENT]}"; \
    do eval "$listener $@"; done
}

addListener(){
  if ! test "${LISTENERS['$1']+isset}"; then LISTENERS["$1"]=""; fi
  LISTENERS["$1"]+="$2 "
}

onExit(){
  return
}

# convert exitcodes to events
trap "throw EXIT"    EXIT
trap "throw SIGINT"  SIGINT
trap "throw SIGTERM" SIGTERM

addListener EXIT onExit


#------------------------------------------------------------------------------
#            __
#     ____  / /___ _____
#    / __ \/ / __ `/ __ \
#   / /_/ / / /_/ / / / /
#  / .___/_/\__,_/_/ /_/
# /_/
#
plan() {
  while getopts :e:l: opt; do
    case "${opt}" in
      e)
        local env=${OPTARG}
        ;;
      l)
        local layer=${OPTARG}
    esac
  done
  shift $((OPTIND-1))

  echo "${env} / ${layer}"

  cd layers/${layer}

  exec &>/dev/tty
  init
  terraform plan -var-file="../../environments/${env}/main.tfvars" -var "layer=${layer}" -var "state_bucket=${STATE_BUCKET}" -var "state_region=${AWS_REGION}"
}


#------------------------------------------------------------------------------
#                      __
#   ____ _____  ____  / /_  __
#  / __ `/ __ \/ __ \/ / / / /
# / /_/ / /_/ / /_/ / / /_/ /
# \__,_/ .___/ .___/_/\__, /
#     /_/   /_/      /____/
#
apply() {
  while getopts :e:l: opt; do
    case "${opt}" in
      e)
        local env=${OPTARG}
        ;;
      l)
        local layer=${OPTARG}
    esac
  done
  shift $((OPTIND-1))

  echo "${env} / ${layer}"

  cd layers/${layer}

  exec &>/dev/tty
  init
  terraform apply -var-file="../../environments/${env}/main.tfvars" -var "layer=${layer}" -var "state_bucket=${STATE_BUCKET}" -var "state_region=${AWS_REGION}"
}


#------------------------------------------------------------------------------
#                __              __
#   ____  __  __/ /_____  __  __/ /_
#  / __ \/ / / / __/ __ \/ / / / __/
# / /_/ / /_/ / /_/ /_/ / /_/ / /_
# \____/\__,_/\__/ .___/\__,_/\__/
#               /_/
output() {
  while getopts :e:l: opt; do
    case "${opt}" in
      e)
        local env=${OPTARG}
        ;;
      l)
        local layer=${OPTARG}
    esac
  done
  shift $((OPTIND-1))

  echo "${env} / ${layer}"

  cd layers/${layer}

  exec &>/dev/tty
  terraform output -json
}


#------------------------------------------------------------------------------
#        __          __
#   ____/ /__  _____/ /__________  __  __
#  / __  / _ \/ ___/ __/ ___/ __ \/ / / /
# / /_/ /  __(__  ) /_/ /  / /_/ / /_/ /
# \__,_/\___/____/\__/_/   \____/\__, /
#                               /____/
destroy() {
  while getopts :e:l: opt; do
    case "${opt}" in
      e)
        local env=${OPTARG}
        ;;
      l)
        local layer=${OPTARG}
    esac
  done
  shift $((OPTIND-1))

  echo "${env} / ${layer}"

  cd layers/${layer}

  exec &>/dev/tty
  init
  terraform destroy -var-file="../../environments/${env}/main.tfvars" -var "layer=${layer}" -var "state_bucket=${STATE_BUCKET}" -var "state_region=${AWS_REGION}"
}


#------------------------------------------------------------------------------
#     _       __                       __  _
#    (_)___  / /____  _________ ______/ /_(_)   _____
#   / / __ \/ __/ _ \/ ___/ __ `/ ___/ __/ / | / / _ \
#  / / / / / /_/  __/ /  / /_/ / /__/ /_/ /| |/ /  __/
# /_/_/ /_/\__/\___/_/   \__,_/\___/\__/_/ |___/\___/
#
# TODO - use the same format for env and layer, without the directory name, or
# there will be too many diferences between the interactive and batch commands.
interactive() {
  exec &>/dev/tty
  local envs=(environments/*/)
  local layers=(layers/*/)
  local commands=(plan apply destroy output)

  PS3="Which environment do you want? "
  echo "Available: ${#envs[@]} ";
  select env in "${envs[@]}"; do echo "You selected ${env}"''; break; done

  PS3="Which layer do you want? "
  echo "Available: ${#layers[@]} ";
  select layer in "${layers[@]}"; do echo "You selected ${layer}"''; break; done

  PS3="Now what? "
  echo "Commands: ${#commands[@]} ";
  select command in "${commands[@]}"; do echo "You selected ${command}"''; break; done

  cd ${layer}
  # TODO make $env and $layer = basename($env) , $layer and for consistency and
  # simplicity in the TF code and so that init works properly

  if [ "${command}" = "output" ]; then
    terraform output -json
  else
    init
    terraform ${command} -var-file="../../${env}main.tfvars" -var "layer=${layer}" -var "state_bucket=${STATE_BUCKET}" -var "state_region=${AWS_REGION}"
  fi
}

#------------------------------------------------------------------------------
#    (_)___  (_) /_
#   / / __ \/ / __/
#  / / / / / / /_
# /_/_/ /_/_/\__/
#------------------------------------------------------------------------------
init() {
  terraform init \
    -backend-config="bucket=${STATE_BUCKET}" \
    -backend-config="key=${PLATFORM_PROJECT}/${env}/${layer}.tfstate" \
    -backend-config="region=${AWS_REGION}" \
    -backend-config="dynamodb_table=${DYNAMO_BACKEND_TABLE}"
}


#------------------------------------------------------------------------------
#     __                __       __
#    / /_  ____  ____  / /______/ /__________ _____
#   / __ \/ __ \/ __ \/ __/ ___/ __/ ___/ __ `/ __ \
#  / /_/ / /_/ / /_/ / /_(__  ) /_/ /  / /_/ / /_/ /
# /_.___/\____/\____/\__/____/\__/_/   \__,_/ .___/
#                                          /_/
bootstrap() {
  ansible-playbook -vvv -i 999_hosts.ini 000_bootstrap.yml
}


#------------------------------------------------------------------------------
#    __                      __
#   / /____  ____ __________/ /___ _      ______
#  / __/ _ \/ __ `/ ___/ __  / __ \ | /| / / __ \
# / /_/  __/ /_/ / /  / /_/ / /_/ / |/ |/ / / / /
# \__/\___/\__,_/_/   \__,_/\____/|__/|__/_/ /_/
#
teardown() {
  ansible-playbook -i 999_hosts.ini 001_teardown.yml
}


#------------------------------------------------------------------------------
#                      _
#     ____ ___  ____ _(_)___
#    / __ `__ \/ __ `/ / __ \
#   / / / / / / /_/ / / / / /
#  /_/ /_/ /_/\__,_/_/_/ /_/
#
[[ -z $1 ]] && interactive

case "${1}" in
  *)
    $1 ${@:2:5}
    ;;
esac
