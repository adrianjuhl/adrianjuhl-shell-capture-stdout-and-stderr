#!/usr/bin/env bash

capture_stdout_and_stderr()
{
  IFS=$'\n' read -r -d '' "${1}" < <(printf 'asdf\0')
  IFS=$'\n' read -r -d '' "${2}" < <(printf 'asdf\0')
}

capture_stdout_and_stderr_help()
{
  echo "capture_stdout_and_stderr"
  echo "Version 0.3.0"
  echo "For usage information call: capture_stdout_and_stderr_help_usage"
}

capture_stdout_and_stderr_help_usage()
{
  echo "capture_stdout_and_stderr"
  echo "Usage:"
  echo
  echo "capture_stdout_and_stderr TODO-show-usage"
}
