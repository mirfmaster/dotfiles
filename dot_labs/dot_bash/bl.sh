#!/usr/bin/env bash

export BASH_LIB_LOG_LEVEL=info

# Add logging functions here
function bl_announce() {
  echo "++++++++++++++++++++++++++++++++++++++"
  echo " "
  echo "$@"
  echo " "
  echo "++++++++++++++++++++++++++++++++++++++"
}

function bl_check_log_level(){
  local level="${1}"
  return 0
  # if [[ ${level} =~ debug|info|warn|error|fatal ]];
  # then
  #   return 0
  # else
  #   echo "${level} is not a valid BASH_LIB_LOG_LEVEL, it should be debug|info|warn|error|fatal"
  #   return 1
  # fi
}

function bl_log {
  declare -A BASH_LIB_LOG_LEVELS=( [debug]=1 [info]=2 [warn]=3 [error]=4 [fatal]=5 )
  declare -A BASH_LIB_LOG_COLOURS=( [debug]="0;37;40" [info]="0;36;40" [warn]="0;33;40" [error]="1;31;40" [fatal]="1;37;41" )
  local runtime_log_level="${BASH_LIB_LOG_LEVEL}"
  local write_log_level="${1}"
  local msg="${2}"
  local out="${3:-stdout}"

  bl_check_log_level "${runtime_log_level}"
  bl_check_log_level "${write_log_level}"

  local runtime_level_num="${BASH_LIB_LOG_LEVELS[${runtime_log_level}]}"
  local write_level_num="${BASH_LIB_LOG_LEVELS[${write_log_level}]}"

  if (( write_level_num < runtime_level_num )); then
    return
  fi

  if [[ "${out}" == "stderr" ]]; then
    echo -e "\e[${BASH_LIB_LOG_COLOURS[${write_log_level}]}m${msg}\e[0m" 1>&2
  else
    echo -e "\e[${BASH_LIB_LOG_COLOURS[${write_log_level}]}m${msg}\e[0m"
  fi
}

function bl_debug(){
  bl_log debug "${*}"
}

function bl_info(){
  bl_log info "${*}"
}

function bl_warn(){
  bl_log warn "${*}"
}

function bl_error(){
  bl_log error "${*}"
}

function bl_fatal(){
  bl_log fatal "${*}"
}

function bl_die(){
    bl_fatal "${@}"
    # exit 1
}

# Retry a command multiple times until it succeeds, with escalating
# delay between attempts.
# Delay is 2 * n + random up to 30s, then 30s + random after that.
# For large numbers of retries the max delay is effectively the retry
# count in minutes.
# Based on:
# https://gist.github.com/sj26/88e1c6584397bb7c13bd11108a579746
# but now quite heavily modified.
function bl_retry {
    # Maxiumum amount of fixed delay between attempts
    # a random value will still be added.
    local -r MAX_BACKOFF=30
    local rc
    local count
    local retries
    local backoff

    if [[ ${#} -lt 2 ]]; then
        bl_die "retry usage: retry <retries> <command>"
    fi

    retries=$1
    shift

    count=0
    until eval "$@"; do
        # Command failed, otherwise until would have skipped the loop

        # Store return code so it can be reported to the user
        rc=$?
        count=$((count + 1))
        if [ "${count}" -lt "${retries}" ]; then
            # There are still retries left, calculate delay and notify user.
            backoff=$((2 * count))
            if [[ "${backoff}" -gt "${MAX_BACKOFF}" ]]; then
                backoff=${MAX_BACKOFF}
            fi;

            # Add a random amount to the delay to prevent competing processes
            # from re-colliding.
            wait=$(( backoff + (RANDOM % count) ))
            bl_info "'${*}' Retry $count/$retries exited $rc, retrying in $wait seconds..."
            sleep $wait
        else
            # Out of retries :(
            bl_error "Retry $count/$retries exited $rc, no more retries left."
            return $rc
        fi
    done
    return 0
}
alias retry=bl_retry

