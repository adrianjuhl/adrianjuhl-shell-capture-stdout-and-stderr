#!/usr/bin/env bash

# Examples of calls to capture_stdout_and_stderr.

capture_stdout_and_stderr_version="0.4.0"

usage()
{
  cat <<USAGE_TEXT
Usage:  ${THIS_SCRIPT_NAME}
            [--help | -h]
            [--script_debug]

Test capture_stdout_and_stderr.

Available options:
    --help, -h
        Print this help and exit.
    --script_debug
        Print script debug info.
USAGE_TEXT
}

main()
{
  initialize
  parse_script_params "${@}"
  # call other functions here
  #echo "THIS_SCRIPT_DIRECTORY is ${THIS_SCRIPT_DIRECTORY}"
  example_calls_to_capture_stdout_and_stderr
  example_calls_to_capture_stdout_and_stderr_help
  example_calls_to_capture_stdout_and_stderr_help_usage
}

simple_function_hello_goodbye_7()
  # outputs "hello" to stdout, "goodbye" to stderr, and sets exit status to 7
{
  printf "hello"
  printf "goodbye" >&2
  return 7
}

example_calls_to_capture_stdout_and_stderr()
{
  echo "Example call to capture_stdout_and_stderr:"
  capture_stdout_and_stderr varout varerr simple_function_hello_goodbye_7
  last_command_return_code="${?}"
  echo "stdout of simple_function_hello_goodbye_7: ${varout}"
  echo "stderr of simple_function_hello_goodbye_7: ${varerr}"
  echo "return code of simple_function_hello_goodbye_7: ${last_command_return_code}"
  echo
}

example_calls_to_capture_stdout_and_stderr_help()
{
  echo "Example call to capture_stdout_and_stderr_help:"
  capture_stdout_and_stderr_help
  echo
}

example_calls_to_capture_stdout_and_stderr_help_usage()
{
  echo "Example call to capture_stdout_and_stderr_help_usage:"
  capture_stdout_and_stderr_help_usage
  echo
}

parse_script_params()
{
  #echo "script params (${#}) are: ${@}"
  # default values of variables set from params
  SCRIPT_DEBUG_OPTION="${FALSE_STRING}"
  while [ "${#}" -gt 0 ]
  do
    case "${1-}" in
      --help | -h)
        usage
        exit
        ;;
      --script_debug)
        set -x
        SCRIPT_DEBUG_OPTION="${TRUE_STRING}"
        ;;
      -?*)
        echo "Error: Unknown parameter: ${1}"
        echo "Use --help for usage help"
        abort_script
        ;;
      *) break ;;
    esac
    shift
  done
}

initialize()
{
  set -o pipefail
  THIS_SCRIPT_PROCESS_ID=$$
  initialize_abort_script_config
  initialize_this_script_directory_variable
  initialize_this_script_name_variable
  initialize_true_and_false_strings
  initialize_function_capture_stdout_and_stderr
}

initialize_abort_script_config()
{
  # Exit shell script from within the script or from any subshell within this script - adapted from:
  # https://cravencode.com/post/essentials/exit-shell-script-from-subshell/
  # Exit with exit status 1 if this (top level process of this script) receives the SIGUSR1 signal.
  # See also the abort_script() function which sends the signal.
  trap "exit 1" SIGUSR1
}

initialize_this_script_directory_variable()
{
  # Determines the value of THIS_SCRIPT_DIRECTORY, the absolute directory name where this script resides.
  # See: https://www.binaryphile.com/bash/2020/01/12/determining-the-location-of-your-script-in-bash.html
  # See: https://stackoverflow.com/a/67149152
  local last_command_return_code
  THIS_SCRIPT_DIRECTORY=$(cd "$(dirname -- "${BASH_SOURCE[0]}")" || exit 1; cd -P -- "$(dirname "$(readlink -- "${BASH_SOURCE[0]}" || echo .)")" || exit 1; pwd)
  last_command_return_code="$?"
  if [ "${last_command_return_code}" -gt 0 ]; then
    echo
    echo "Error: Failed to determine the value of THIS_SCRIPT_DIRECTORY."
    echo
    abort_script
  fi
}

initialize_this_script_name_variable()
{
  local path_to_invoked_script
  local default_script_name
  path_to_invoked_script="${BASH_SOURCE[0]}"
  default_script_name=""
  if grep -q '/dev/fd' <(dirname "${path_to_invoked_script}"); then
    # The script was invoked via process substitution
    if [ -z "${default_script_name}" ]; then
      THIS_SCRIPT_NAME="<script invoked via file descriptor (process substitution) and no default name set>"
    else
      THIS_SCRIPT_NAME="${default_script_name}"
    fi
  else
    THIS_SCRIPT_NAME="$(basename "${path_to_invoked_script}")"
  fi
}

initialize_true_and_false_strings()
{
  # Bash doesn't have a native true/false, just strings and numbers,
  # so this is as clear as it can be, using, for example:
  # if [ "${my_boolean_var}" = "${TRUE_STRING}" ]; then
  # where previously 'my_boolean_var' is set to either ${TRUE_STRING} or ${FALSE_STRING}
  TRUE_STRING="true"
  FALSE_STRING="false"
}

initialize_function_capture_stdout_and_stderr()
{
  local capture_stdout_and_stderr_script_path
  capture_stdout_and_stderr_script_path="${THIS_SCRIPT_DIRECTORY}/../bin/capture_stdout_and_stderr.sh"
  if [ -f "${capture_stdout_and_stderr_script_path}" ]; then
    source "${capture_stdout_and_stderr_script_path}"
  else
    echo >&2 "[WARNING] capture_stdout_and_stderr script file was not found (${capture_stdout_and_stderr_script_path})."
  fi
}

abort_script()
{
  echo >&2 "aborting..."
  kill -SIGUSR1 ${THIS_SCRIPT_PROCESS_ID}
  exit
}

# Main entry into the script - call the main() function
main "${@}"
