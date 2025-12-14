#!/usr/bin/env bash

# capture_stdout_and_stderr()
# Capture a command's (or function's) standard out and standard error.
# Any nulls present in standard out and standard error are stripped out.
# Usage: capture_stdout_and_stderr stdout_var_name stderr_var_name command_or_function [parameter]...
capture_stdout_and_stderr()
{
  __capture_stdout_and_stderr strip_nulls "${@}"
}

# capture_stdout_and_stderr_base64()
# Capture a command's (or function's) standard out and standard error.
# The standard out and standard error values are base64 encoded; nulls are preserved.
# Usage: capture_stdout_and_stderr_base64 stdout_var_name stderr_var_name command_or_function [parameter]...
capture_stdout_and_stderr_base64()
{
  __capture_stdout_and_stderr base64_encode "${@}"
}

__capture_stdout_and_stderr()
{
  local stdout_variable_name
  local stderr_variable_name
  local return_status
  local sanitize_command
  if [ "base64_encode" == "${1}" ]; then
    sanitize_command="base64"
  fi
  if [ "strip_nulls" == "${1}" ]; then
    sanitize_command="tr -d '\0'"
  fi
  stdout_variable_name="${2}"
  stderr_variable_name="${3}"
  if [ -z "${stdout_variable_name}" ]; then
    echo >&2 "Error: [in capture_stdout_and_stderr()] Missing required first parameter (stdout variable name)"
    return 1
  fi
  if [ -z "${stderr_variable_name}" ]; then
    echo >&2 "Error: [in capture_stdout_and_stderr()] Missing required second parameter (stderr variable name)"
    return 1
  fi
  shift 3;
  if [ -z "${*}" ]; then
    echo >&2 "Error: [in capture_stdout_and_stderr()] Missing required third parameter (command and its parameters)"
    return 1
  fi
  {
    IFS=$'\n' read -r -d '' "${stdout_variable_name}";
    IFS=$'\n' read -r -d '' "${stderr_variable_name}";
    IFS=$'\n' read -r -d '' "return_status";
    return "${return_status}";
  } < <(
          set +x # Turn off 'xtrace' in this sub-shell that runs and captures the stdout and stderr of the command as the trace output conflicts and gets intermingled with the command's stderr.
          {
            {
              {
                {
                  "${@}" 1>&11 2>&12
                  echo "${?}" 1>&13
                } 11>&1 | eval "${sanitize_command}" | xargs -0 printf '%s\0' 1>&11
              } 12>&1 | eval "${sanitize_command}" | xargs -0 printf '%s\0' 1>&12
            } 13>&1 | xargs -0 printf '%s\0' 1>&13
          } 11>&1 12>&1 13>&1
       )
}

capture_stdout_and_stderr_help()
{
  cat <<HELP_TEXT
capture_stdout_and_stderr
Version 0.6.0
For usage information call: capture_stdout_and_stderr_help_usage
HELP_TEXT
}

capture_stdout_and_stderr_help_usage()
{
  cat <<USAGE_TEXT
capture_stdout_and_stderr

Usage: capture_stdout_and_stderr <stdout_capture_variable_name> <stderr_capture_variable_name> <name_of_command_or_function_to_call> [parameter]...

Example:

sample_function()
  # outputs "hello" to stdout, "goodbye" to stderr, and sets exit status to 7
{
  printf "hello"
  printf "goodbye" >&2
  return 7
}

capture_stdout_and_stderr my_stdout_var my_stderr_var sample_function
sample_function_return_code="${?}"
# At this point:
#   - the my_stdout_var variable will have the value "hello"
#   - the my_stderr_var variable will have the value "goodbye"
#   - the sample_function_return_code variable will have the value "7"
USAGE_TEXT
}
