#!/usr/bin/env bash

capture_stdout_and_stderr()
{
  local stdout_variable_name
  local stderr_variable_name
  local return_status
  stdout_variable_name="${1}"
  stderr_variable_name="${2}"
  if [ -z "${stdout_variable_name}" ]; then
    echo >&2 "Error: [in capture_stdout_and_stderr()] Missing required first parameter (stdout variable name)"
    return 1
  fi
  if [ -z "${stderr_variable_name}" ]; then
    echo >&2 "Error: [in capture_stdout_and_stderr()] Missing required second parameter (stderr variable name)"
    return 1
  fi
  shift 2;
  "${@}" >/dev/null 2>&1;
  return_status="${?}";
  IFS=$'\n' read -r -d '' "${stdout_variable_name}" < <(printf 'asdf\0');
  IFS=$'\n' read -r -d '' "${stderr_variable_name}" < <(printf 'asdf\0');
  return "${return_status}";
}

capture_stdout_and_stderr_help()
{
  echo "capture_stdout_and_stderr"
  echo "Version 0.5.0"
  echo "For usage information call: capture_stdout_and_stderr_help_usage"
}

capture_stdout_and_stderr_help_usage()
{
  echo "capture_stdout_and_stderr"
  echo "Usage:"
  echo
  echo "capture_stdout_and_stderr TODO-show-usage"
}
